extends Node

var _api: DTAPI
var _userRef: String
var _types: Dictionary
var _actions: Dictionary

@export
var asset: Array[DTActorAsset]

## Called after successful registration
signal registerSuccess

## Called after failed registration
signal registerFailed

## Called after successful login
signal loginSuccess

## Called after failed login
signal loginFailed

# Establish API and query available gameplay data from server
func _ready():
	_api = DTAPI.new()
	
	_api.getGameTypes(
		func(data): _onTypesReceived(data as Array[Dictionary]), 
		func(errorCode, message): _onRegisterFailed(errorCode, message))
		
	_api.getGameActions(
		func(data): _onActionsReceived(data as Array[Dictionary]), 
		func(errorCode, message): _onRegisterFailed(errorCode, message))

func _process(delta):
	pass

func _onTypesReceived(types: Array[Dictionary]):
	for type in types:
		_types[type["typeReg"]] = DTType.new(type)

func _onActionsReceived(actions: Array[Dictionary]):
	for action in actions:
		_actions[action["actionReg"]] = DTAction.new(action)

## Register a new user with the given credentials.
func register(username: String, password: String, nickname: String):
	if not _api:
		return false
	_api.postPlayerRegister({"username": username, "password": password, "nickname": nickname}, 
		func(data): _onRegister(data), 
		func(errorCode, message): _onRegisterFailed(errorCode, message))
	return true

func _onRegister(userRef: String):
	emit_signal("registerSuccess")

func _onRegisterFailed(errorCode: int, message: String):
	emit_signal("registerFailed")



## Login a user with the given credentials.
## This will enable calls to API endpoints that require a valid user token and 
## associates this node with the logged in user.
func login(username: String, password: String):
	if not _api:
		return false
	_api.postPlayerLogin({"username": username, "password": password}, 
		func(data): _onLogin(data["token"], data["userRef"]),
		func(errorCode, message): _onLoginFailed(errorCode, message))
	return true

func _onLogin(token: String, userRef: String):
	_api.authenticate(token)
	_userRef = userRef
	emit_signal("loginSuccess")

func _onLoginFailed(errorCode: int, message: String):
	emit_signal("loginFailed")
