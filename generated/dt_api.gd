
class_name DTAPI
extends DTRequester

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
func getGameTypes(callback: Callable):
	var params = {}
	var queries = {}
	return requestGet("/game/Types", params, queries, callback)

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
func getGameActions(callback: Callable):
	var params = {}
	var queries = {}
	return requestGet("/game/Actions", params, queries, callback)

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
func getGameEntityListWith(typeReg:String, callback: Callable):
	var params = {"typeReg": str(typeReg)}
	var queries = {}
	return requestGet("/game/entity/list/{typeReg}", params, queries, callback)

## 
##	typeReg: String
##	body: Dictionary
##		name: String
##		isPublic: bool
##	return: String
func postGameEntityWith(typeReg:String, body: Dictionary, callback: Callable):
	var params = {"typeReg": str(typeReg)}
	var queries = {}
	return requestPost("/game/entity/{typeReg}", params, queries, body, callback)

## 
##	entityRef: String
##	body: Dictionary
##		name: String
##		isPublic: bool
func putGameEntityWith(entityRef:String, body: Dictionary, callback: Callable):
	var params = {"entityRef": str(entityRef)}
	var queries = {}
	return requestPut("/game/entity/{entityRef}", params, queries, body, callback)

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
func getGameEntityWith(entityRef:String, callback: Callable):
	var params = {"entityRef": str(entityRef)}
	var queries = {}
	return requestGet("/game/entity/{entityRef}", params, queries, callback)

## 
##	entityRef: String
func deleteGameEntityWith(entityRef:String, callback: Callable):
	var params = {"entityRef": str(entityRef)}
	var queries = {}
	return requestDelete("/game/entity/{entityRef}", params, queries, callback)

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
func getGameListEntities(entityRefs:Array[String], callback: Callable):
	var params = {}
	var queries = {"entityRefs": str(entityRefs)}
	return requestGet("/game/list/entities", params, queries, callback)

## 
##	entityRef: String
##	body: Dictionary
##		playerRefs: Array[String]
func putGameEntityWithOwnership(entityRef:String, body: Dictionary, callback: Callable):
	var params = {"entityRef": str(entityRef)}
	var queries = {}
	return requestPut("/game/entity/{entityRef}/ownership", params, queries, body, callback)

## 
##	entityRef: String
##	sceneReg: String
##	body: Dictionary
##		name: String
##	return: String
func postGameEntityWithSceneWith(entityRef:String, sceneReg:String, body: Dictionary, callback: Callable):
	var params = {"entityRef": str(entityRef),
		"sceneReg": str(sceneReg)}
	var queries = {}
	return requestPost("/game/entity/{entityRef}/scene/{sceneReg}", params, queries, body, callback)

## 
##	entityRef: String
##	sceneReg: String
func deleteGameEntityWithSceneWith(entityRef:String, sceneReg:String, callback: Callable):
	var params = {"entityRef": str(entityRef),
		"sceneReg": str(sceneReg)}
	var queries = {}
	return requestDelete("/game/entity/{entityRef}/scene/{sceneReg}", params, queries, callback)

## Authenticate with server and return JWToken.
##	body: Dictionary
##		username: String
##		password: String
##	return: Dictionary
##		token: String
##		playerRef: String
func postPlayerLogin(body: Dictionary, callback: Callable):
	var params = {}
	var queries = {}
	return requestPost("/player/login", params, queries, body, callback)

## Register yourself to this server if enabled.
##	body: Dictionary
##		username: String
##		password: String
##		nickname: String
##	return: String
func postPlayerRegister(body: Dictionary, callback: Callable):
	var params = {}
	var queries = {}
	return requestPost("/player/register", params, queries, body, callback)

## Create new user on this server.
##	body: Dictionary
##		username: String
##		password: String
##		nickname: String
##	return: String
func postPlayer(body: Dictionary, callback: Callable):
	var params = {}
	var queries = {}
	return requestPost("/player", params, queries, body, callback)

## 
##	return: Dictionary // Private-facing information about a player
##		ref: String // ID of this player
##		nickname: String // Displayed player name
##		access: int // Displayed role
##		username: String // Displayed user name
func getPlayer(callback: Callable):
	var params = {}
	var queries = {}
	return requestGet("/player", params, queries, callback)

## 
##	body: Dictionary
##		username: String
##		password: String
##		nickname: String
func putPlayer(body: Dictionary, callback: Callable):
	var params = {}
	var queries = {}
	return requestPut("/player", params, queries, body, callback)

## Removes calling player from server.
func deletePlayer(callback: Callable):
	var params = {}
	var queries = {}
	return requestDelete("/player", params, queries, callback)

## 
##	playerRef: String
##	return: Dictionary // Public-facing information about a player
##		ref: String // ID of this player
##		nickname: String // Displayed player name
##		access: int // Displayed role
func getPlayerWith(playerRef:String, callback: Callable):
	var params = {"playerRef": str(playerRef)}
	var queries = {}
	return requestGet("/player/{playerRef}", params, queries, callback)

## 
##	playerRef: String
##	body: Dictionary
##		username: String
##		password: String
##		nickname: String
func putPlayerWith(playerRef:String, body: Dictionary, callback: Callable):
	var params = {"playerRef": str(playerRef)}
	var queries = {}
	return requestPut("/player/{playerRef}", params, queries, body, callback)

## Removes a player from this server. Users that are moderators or admins cannot be removed and must be demoted first.
##	playerRef: String
func deletePlayerWith(playerRef:String, callback: Callable):
	var params = {"playerRef": str(playerRef)}
	var queries = {}
	return requestDelete("/player/{playerRef}", params, queries, callback)

## 
##	playerRef: String
##	query: String
func putPlayerWithWith(playerRef:String, query:String, body: Dictionary, callback: Callable):
	var params = {"playerRef": str(playerRef),
		"query": str(query)}
	var queries = {}
	return requestPut("/player/{playerRef}/{query}", params, queries, body, callback)

## Start a new session as currently logged in player. After a session has been started, the player needs to query for an update every so often (even if they don't observe any entities) or the server assumes the player has disconnected.  Note that we give players the ability to have multiple sessions active at the same time, e.g. if they're running the game multiple times in different windows.
##	body: Dictionary
##		entityRefs: Array[String]
##	return: String
func postSessionStart(body: Dictionary, callback: Callable):
	var params = {}
	var queries = {}
	return requestPost("/session/start", params, queries, body, callback)

## Subscribe to timeline changes (SSE). Setup can take a while so this will also perform a diff on the database. Usually a client will first do an update with refresh and then subscribe to further changes.
func getSessionEventsWith(callback: Callable):
	var params = {}
	var queries = {}
	return requestGet("/session/events/{sessionReg}", params, queries, callback)

## Get pending updates from an active session. Also refresh the heartbeat timer so that the session keeps on living.
##	sessionReg: String
##	return: Array[Dictionary]
##		entityRef: String
##		propReg: String
##		timestamp: String
##		duration: float
##		propVal: String
func postSessionUpdateWith(sessionReg:String, body: Dictionary, callback: Callable):
	var params = {"sessionReg": str(sessionReg)}
	var queries = {}
	return requestPost("/session/update/{sessionReg}", params, queries, body, callback)

## Get state from an active session and resets session queue. This directly queries the database and discards current session state.
##	sessionReg: String
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
func postSessionResetWithFromWithWith(sessionReg:String, date:String, query:String, body: Dictionary, callback: Callable):
	var params = {"sessionReg": str(sessionReg),
		"date": str(date),
		"query": str(query)}
	var queries = {}
	return requestPost("/session/reset/{sessionReg}/from/{date}/{query}", params, queries, body, callback)

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
func getSessionSpectateWithFromWithWith(entityRef:String, date:String, query:String, callback: Callable):
	var params = {"entityRef": str(entityRef),
		"date": str(date),
		"query": str(query)}
	var queries = {}
	return requestGet("/session/spectate/{entityRef}/from/{date}/{query}", params, queries, callback)

## Stop a session. This should be called once player disconnects.
##	sessionReg: String
func deleteSessionStopWith(sessionReg:String, callback: Callable):
	var params = {"sessionReg": str(sessionReg)}
	var queries = {}
	return requestDelete("/session/stop/{sessionReg}", params, queries, callback)
