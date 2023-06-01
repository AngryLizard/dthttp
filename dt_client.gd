extends Node

var _api: DTAPI = null
var _userRef: String = ""
var _sessionRef: String = ""
var _lastUpdate: String = ""

var _types: Dictionary = {}
var _actions: Dictionary = {}
var _entities: Dictionary = {}

var _changeQueue: Array[Dictionary] = []

## Called after types were successfully loaded with a list of all available types Array[DTType].
## This can be used to populate gameplay elements that rely on types.
signal types_loaded

## Called after actions were successful loaded with a list of all available actions Array[DTAction].
## This can be used to populate gameplay elements that rely on actions.
signal actions_loaded

## Called if there was a fatal error loading game data from the server.
## Use this signal to e.g. boot the user back to the main menu to try another connection.
signal connection_failed

## Called after successful login
signal logged_in

## Called when a session is started
signal session_started

## Get type for a type name.
## This getter is only available after types have loaded.
func get_type(typeReg: String) -> DTType:
	if typeReg.is_empty():
		return null
	if typeReg in _types:
		return _types[typeReg]
	push_error("Type with name %s not found" % [typeReg])
	return null
	
## Get action for a action name
## This getter is only available after actions have loaded.
func get_action(actionReg: String) -> DTAction:
	if actionReg.is_empty():
		return null
	if actionReg in _actions:
		return _actions[actionReg]
	push_error("Action with name %s not found" % [actionReg])
	return null

## Get whether this client has an associated logged in user
func is_logged_in() -> bool:
	return not _userRef.is_empty()
	
## Get whether this client has an associated logged in user
func has_active_session() -> bool:
	return not _sessionRef.is_empty()

## Establish API and starts loading available gameplay data from server.
## If a user is already assigned they're logged out and all data is reset.
## Callback is called when connection is established. Types/actions might still be
## loading after callback; use the types_loaded and actions_loaded signals instead.
func connectToServer(domain:String, onConnected:Callable):
	_userRef = ""
	_types = {}
	_actions = {}
	
	_api = DTAPI.new(domain)
	# TODO: For now we "establish" the connection once actions and types are loaded.
	# Though in the future we should use a dedicated endpoint for that: player doesn't
	# have to wait for types and actions to be received before starting the login process.
	
	_api.get_game_types(
		func(types: Array[Dictionary]):
			for type in types:
				_types[type["typeReg"]] = DTType.new(type)
			types_loaded.emit(_types.values)
			# TODO: use other endpoint for callback
			if not _actions.is_empty():
				onConnected.call(),
		func(errorCode, message):
			disconnect_from_server()
			connection_failed.emit())
		
	_api.get_game_actions(
		func(actions: Array[Dictionary]): 
			for action in actions:
				_actions[action["actionReg"]] = DTAction.new(action)
			actions_loaded.emit(_actions.values)
			# TODO: use other endpoint for callback
			if not _types.is_empty():
				onConnected.call(),
		func(errorCode, message):
			disconnect_from_server()
			connection_failed.emit())

## Close connection and clear all data. This call is specifically client-side,
## no end-session or logout is performed.
func disconnect_from_server():
	_api = null
	_userRef = ""
	_sessionRef = ""
	_lastUpdate = ""
	
	_types = {}
	_actions = {}
	_entities = {}
	
	_changeQueue = []
	
enum RegisterError {
	INTERNAL, # Internal server error
	PASSWORD, # The password didn't comply with server rules
	ACCOUNT # There was a problem with the input (duplicate account, etc.)
}

## Register a new user with the given credentials.
## The newly created user will *not* be logged in automatically.
## Callback is called on success, or failure with a DTClient.RegisterError
func register(username: String, password: String, nickname: String, onSuccess:Callable, onFailure:Callable) -> bool:
	if not _api:
		push_error("Trying to call endpoint with invlid API. Make sure to connect to server before calling register.")
		return false
		
	_api.post_player_register({"username": username, "password": password, "nickname": nickname}, 
		func(data: Dictionary): 
			onSuccess.call(), 
		func(errorCode, message):
			# TODO: Properly define more errors based on error codes
			onFailure.call(RegisterError.INTERNAL))
	return true

enum LoginError {
	INTERNAL, # Internal server error
	AUTHENTICATION # User doesn't exist or password mismatch
}

## Login a user with the given credentials.
## This will enable calls to API endpoints that require a valid user token and 
## associates this node with the logged in user. Calls logged_in signal on success.
## Callback is called on success, or failure with a DTClient.LoginError
func login(username: String, password: String, onSuccess:Callable, onFailure:Callable) -> bool:
	if not _api:
		push_error("Trying to call endpoint with invlid API. Make sure to connect to server before calling login.")
		return false
		
	_api.post_player_login({"username": username, "password": password}, 
		func(data: Dictionary): 
			_api.authenticate(data["token"])
			_userRef = data["userRef"]
			logged_in.emit()
			onSuccess.call(),
		func(errorCode, message):
			# TODO: Properly define more errors based on error codes
			onFailure.call(LoginError.INTERNAL))
	return true

## Get a list of all game objects of a specific type that currently logged in user (or spectator) has access to.
## Callback is called on success with Array[DTObject], or on failure.
func get_available_objects(typeReg: String, onSuccess:Callable, onFailure:Callable) -> bool:
	if not _api:
		push_error("Trying to call endpoint with invlid API. Make sure to connect to server before calling get_available_objects.")
		return false
		
	_api.get_game_entity_list_with(typeReg,
		func(data: Array[Dictionary]):
			var entities = []
			for entityData in data:
				entities.append(DTEntity.new(entityData))
			onSuccess.call(entities),
		func(errorCode, message):
			onFailure.call())
	return true

## Start a user session with the given entities. The user will be "observing" these 
## entities and get status updates for all changes that happen in their visibility.
## This will start listening for updates until connection to server is lost or the session is stopped.
## Callback is called on success or on failure. There can only be one active session at a time.
func start_session(entityRefs: Array[String], onSuccess:Callable, onFailure:Callable) -> bool:
	if not _api:
		push_error("Trying to call endpoint with invlid API. Make sure to connect to server before calling start_session.")
		return false
	if not is_logged_in():
		push_error("Trying to call user endpoint while not logged in. Make sure to log user in before calling start_session.")
		return false
	if has_active_session():
		push_error("Trying to start a session while one is already active. Stop the current session first.")
		return false
		
	_api.post_session_start({"entityRefs": entityRefs},
		func(sessionRef: String):
			_sessionRef = sessionRef
			session_started.emit()
			_run_sse()
			onSuccess.call(),
		func(errorCode, message):
			onFailure.call())
	return true

## Ends the currently active session. Also stops any currently active update events.
func end_session(onSuccess:Callable, onFailure:Callable) -> bool:
	if not _api:
		push_error("Trying to call endpoint with invlid API. Make sure to connect to server before calling end_session.")
		return false
	if not has_active_session():
		push_error("Trying to end the session while none is active.")
		return false
		
	_api.delete_session_stop_with(_sessionRef, 
		func(data):
			_sessionRef = ""
			onSuccess.call(),
		func(errorCode, message):
			disconnect_from_server()
			onFailure.call())
	return true

## Force an update for all observed entities of the current session.
## Callback is called on success or on failure. Updates are normally received via 
## server-side events (SSE) but this function can be used to fix invalid data. 
## Will do a hard reset on all visible entities if refresh is true, otherwise
## will only get a diff since the last SSE or forced update.
func force_update_session(refresh: bool, onSuccess:Callable, onFailure:Callable):
	if not _api:
		push_error("Trying to call endpoint with invlid API. Make sure to connect to server before calling end_session.")
		return false
	if not has_active_session():
		push_error("Can't update game data without an active session.")
		return false
		
	var date = ""
	_api.post_session_update_with_from_with_with(_sessionRef, date, "refresh" if refresh else "diff", {},
		func(data: Dictionary):
			_lastUpdate = data['timestamp']
			_push_changes(data['changes'])
			onSuccess.call(),
		func(errorCode, message):
			connection_failed.emit()
			onFailure.call())
	return true

func _run_sse():
	
	pass

func _push_changes(changes: Array[Dictionary]):
	# If we're already waiting on an update wait for that instead
	if not _changeQueue.is_empty():
		_changeQueue.append_array(changes)
		return
	
	# Apply each update in the order it arrived
	var unknownEntities: Array[String] = []
	for change in changes:
		var entityRef = change['entityRef']
		if entityRef in _entities:
			var entity = _entities[entityRef] as DTBaseObject
			entity.push_property_change(change)
		else:
			# Collect entities that aren't known to the system yet and process them afterwards
			_changeQueue.append(changes)
			unknownEntities.append(entityRef)
	
	# Process all unkown entities
	if unknownEntities.is_empty():
		_api.get_game_list_entities(unknownEntities, 
			func (data: Array[Dictionary]):
				for entityData in data:
					_entities[entityData["entityRef"]] = DTEntity.new(entityData)
				# Run queue again
				var queue = _changeQueue
				_changeQueue = []
				_push_changes(queue),
			func(errorCode, message):
				disconnect_from_server()
				connection_failed.emit())
