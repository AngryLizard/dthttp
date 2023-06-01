
class_name DTAPI
extends DTRequester

func _init(domain: String = ""):
	super._init(domain)

## 
##	return: Array[Dictionary]
##		typeReg: String
##		asset: String
##		parent: String
##		desc: String
##		props: Array[Dictionary]
##			propReg: String
##			desc: String
##			type: String
##			initial: String
##		attrs: Array[Dictionary]
##			propReg: String
##			desc: String
##			type: String
##			initial: String
func get_game_types(onSuccess: Callable, onError: Callable):
	var params = {}
	var queries = {}
	return requestGet("/game/Types", params, queries, onSuccess, onError)

## 
##	return: Array[Dictionary]
##		actionReg: String
##		domain: String
##		trigger: String
##		desc: String
##		params: Array[Dictionary]
##			paramReg: String
##			input: String
##			desc: String
##			type: String
##			initial: String
func get_game_actions(onSuccess: Callable, onError: Callable):
	var params = {}
	var queries = {}
	return requestGet("/game/Actions", params, queries, onSuccess, onError)

## 
##	typeReg: String
##	return: Array[Dictionary] // Generally addressable objects in the game
##		ref: String // ID of this entity
##		name: String // Name of this entity
##		typeReg: String // Type of this entity
##		ownerRefs: Array[String] // Owners over this entity
##		attributes: Array[Dictionary] // Attributes of this entity
##			propReg: String // Property name, should correspond to an attribute in the entity type
##			propVal: String // Property value whose format corresponds to property type assigned by propKey
func get_game_entity_list_with(typeReg:String, onSuccess: Callable, onError: Callable):
	var params = {"typeReg": str(typeReg)}
	var queries = {}
	return requestGet("/game/entity/list/{typeReg}", params, queries, onSuccess, onError)

## 
##	typeReg: String
##	body: Dictionary
##		name: String
##		isPublic: bool
##	return: String
func post_game_entity_with(typeReg:String, body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {"typeReg": str(typeReg)}
	var queries = {}
	return requestPost("/game/entity/{typeReg}", params, queries, body, onSuccess, onError)

## 
##	entityRef: String
##	body: Dictionary
##		name: String
##		isPublic: bool
func put_game_entity_with(entityRef:String, body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {"entityRef": str(entityRef)}
	var queries = {}
	return requestPut("/game/entity/{entityRef}", params, queries, body, onSuccess, onError)

## 
##	entityRef: String
##	return: Dictionary // Generally addressable objects in the game
##		ref: String // ID of this entity
##		name: String // Name of this entity
##		typeReg: String // Type of this entity
##		ownerRefs: Array[String] // Owners over this entity
##		attributes: Array[Dictionary] // Attributes of this entity
##			propReg: String // Property name, should correspond to an attribute in the entity type
##			propVal: String // Property value whose format corresponds to property type assigned by propKey
func get_game_entity_with(entityRef:String, onSuccess: Callable, onError: Callable):
	var params = {"entityRef": str(entityRef)}
	var queries = {}
	return requestGet("/game/entity/{entityRef}", params, queries, onSuccess, onError)

## 
##	entityRef: String
func delete_game_entity_with(entityRef:String, onSuccess: Callable, onError: Callable):
	var params = {"entityRef": str(entityRef)}
	var queries = {}
	return requestDelete("/game/entity/{entityRef}", params, queries, onSuccess, onError)

## 
##	entityRefs: Array[String]
##	return: Array[Dictionary] // Generally addressable objects in the game
##		ref: String // ID of this entity
##		name: String // Name of this entity
##		typeReg: String // Type of this entity
##		ownerRefs: Array[String] // Owners over this entity
##		attributes: Array[Dictionary] // Attributes of this entity
##			propReg: String // Property name, should correspond to an attribute in the entity type
##			propVal: String // Property value whose format corresponds to property type assigned by propKey
func get_game_list_entities(entityRefs:Array[String], onSuccess: Callable, onError: Callable):
	var params = {}
	var queries = {"entityRefs": str(entityRefs)}
	return requestGet("/game/list/entities", params, queries, onSuccess, onError)

## 
##	entityRef: String
##	body: Dictionary
##		playerRefs: Array[String]
func put_game_entity_with_ownership(entityRef:String, body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {"entityRef": str(entityRef)}
	var queries = {}
	return requestPut("/game/entity/{entityRef}/ownership", params, queries, body, onSuccess, onError)

## 
##	entityRef: String
##	sceneReg: String
##	body: Dictionary
##		name: String
##	return: String
func post_game_entity_with_scene_with(entityRef:String, sceneReg:String, body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {"entityRef": str(entityRef),
		"sceneReg": str(sceneReg)}
	var queries = {}
	return requestPost("/game/entity/{entityRef}/scene/{sceneReg}", params, queries, body, onSuccess, onError)

## 
##	entityRef: String
##	sceneReg: String
func delete_game_entity_with_scene_with(entityRef:String, sceneReg:String, onSuccess: Callable, onError: Callable):
	var params = {"entityRef": str(entityRef),
		"sceneReg": str(sceneReg)}
	var queries = {}
	return requestDelete("/game/entity/{entityRef}/scene/{sceneReg}", params, queries, onSuccess, onError)

## Authenticate with server and return JWToken.
##	body: Dictionary
##		username: String
##		password: String
##	return: Dictionary
##		token: String
##		playerRef: String
func post_player_login(body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {}
	var queries = {}
	return requestPost("/player/login", params, queries, body, onSuccess, onError)

## Register yourself to this server if enabled.
##	body: Dictionary
##		username: String
##		password: String
##		nickname: String
##	return: String
func post_player_register(body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {}
	var queries = {}
	return requestPost("/player/register", params, queries, body, onSuccess, onError)

## Create new user on this server.
##	body: Dictionary
##		username: String
##		password: String
##		nickname: String
##	return: String
func post_player(body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {}
	var queries = {}
	return requestPost("/player", params, queries, body, onSuccess, onError)

## 
##	return: Dictionary // Private-facing information about a player
##		ref: String // ID of this player
##		nickname: String // Displayed player name
##		access: int // Displayed role
##		username: String // Displayed user name
func get_player(onSuccess: Callable, onError: Callable):
	var params = {}
	var queries = {}
	return requestGet("/player", params, queries, onSuccess, onError)

## 
##	body: Dictionary
##		username: String
##		password: String
##		nickname: String
func put_player(body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {}
	var queries = {}
	return requestPut("/player", params, queries, body, onSuccess, onError)

## Removes calling player from server.
func delete_player(onSuccess: Callable, onError: Callable):
	var params = {}
	var queries = {}
	return requestDelete("/player", params, queries, onSuccess, onError)

## 
##	playerRef: String
##	return: Dictionary // Public-facing information about a player
##		ref: String // ID of this player
##		nickname: String // Displayed player name
##		access: int // Displayed role
func get_player_with(playerRef:String, onSuccess: Callable, onError: Callable):
	var params = {"playerRef": str(playerRef)}
	var queries = {}
	return requestGet("/player/{playerRef}", params, queries, onSuccess, onError)

## 
##	playerRef: String
##	body: Dictionary
##		username: String
##		password: String
##		nickname: String
func put_player_with(playerRef:String, body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {"playerRef": str(playerRef)}
	var queries = {}
	return requestPut("/player/{playerRef}", params, queries, body, onSuccess, onError)

## Removes a player from this server. Users that are moderators or admins cannot be removed and must be demoted first.
##	playerRef: String
func delete_player_with(playerRef:String, onSuccess: Callable, onError: Callable):
	var params = {"playerRef": str(playerRef)}
	var queries = {}
	return requestDelete("/player/{playerRef}", params, queries, onSuccess, onError)

## 
##	playerRef: String
##	query: String
func put_player_with_with(playerRef:String, query:String, body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {"playerRef": str(playerRef),
		"query": str(query)}
	var queries = {}
	return requestPut("/player/{playerRef}/{query}", params, queries, body, onSuccess, onError)

## Start a new session as currently logged in player. After a session has been started, the player needs to query for an update every so often (even if they don't observe any entities) or the server assumes the player has disconnected.  Note that we give players the ability to have multiple sessions active at the same time, e.g. if they're running the game multiple times in different windows.
##	body: Dictionary
##		entityRefs: Array[String]
##	return: String
func post_session_start(body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {}
	var queries = {}
	return requestPost("/session/start", params, queries, body, onSuccess, onError)

## Subscribe to timeline changes (SSE).
func get_session_events_with(onSuccess: Callable, onError: Callable):
	var params = {}
	var queries = {}
	return requestGet("/session/events/{sessionRef}", params, queries, onSuccess, onError)

## Get updates from an active session. Also refresh the heartbeat timer so that the session keeps on living.
##	sessionRef: String
##	date: String
##	query: String
##	return: Dictionary
##		changes: Array[Dictionary]
##			entityRef: String
##			propReg: String
##			timestamp: String
##			duration: float
##			propVal: String
##		timestamp: String
func post_session_update_with_from_with_with(sessionRef:String, date:String, query:String, body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {"sessionRef": str(sessionRef),
		"date": str(date),
		"query": str(query)}
	var queries = {}
	return requestPost("/session/update/{sessionRef}/from/{date}/{query}", params, queries, body, onSuccess, onError)

## This endpoint lets non-registered players observe a session if enabled on this server and on entities that allow it. It is restricted to only one entity and we always assume a full refresh to allow for caching.
##	entityRef: String
##	date: String
##	query: String
##	return: Dictionary
##		changes: Array[Dictionary]
##			entityRef: String
##			propReg: String
##			timestamp: String
##			duration: float
##			propVal: String
##		timestamp: String
func get_session_spectate_with_from_with_with(entityRef:String, date:String, query:String, onSuccess: Callable, onError: Callable):
	var params = {"entityRef": str(entityRef),
		"date": str(date),
		"query": str(query)}
	var queries = {}
	return requestGet("/session/spectate/{entityRef}/from/{date}/{query}", params, queries, onSuccess, onError)

## Stop a session. This should be called once player disconnects.
##	sessionRef: String
func delete_session_stop_with(sessionRef:String, onSuccess: Callable, onError: Callable):
	var params = {"sessionRef": str(sessionRef)}
	var queries = {}
	return requestDelete("/session/stop/{sessionRef}", params, queries, onSuccess, onError)

## Post dialogue from calling entity
##	entityRef: String
##	body: Dictionary
##		message: String // Post dialogue from calling entity
##		speed: float // Post dialogue from calling entity
func post_action_with_dialogue(entityRef:String, body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {"entityRef": str(entityRef)}
	var queries = {}
	return requestPost("/action/{entityId}/Dialogue", params, queries, body, onSuccess, onError)

## Move calling entity
##	entityRef: String
##	body: Dictionary
##		target: string // Move calling entity
##		speed: float // Move calling entity
func post_action_with_move(entityRef:String, body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {"entityRef": str(entityRef)}
	var queries = {}
	return requestPost("/action/{entityId}/Move", params, queries, body, onSuccess, onError)

## Spawn calling entity
##	entityRef: String
##	body: Dictionary
##		spawnerId: string // Spawn calling entity
func post_action_with_spawn(entityRef:String, body: Dictionary, onSuccess: Callable, onError: Callable):
	var params = {"entityRef": str(entityRef)}
	var queries = {}
	return requestPost("/action/{entityId}/Spawn", params, queries, body, onSuccess, onError)
