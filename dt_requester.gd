class_name DTRequester
extends Node

var _domain: String = ""
var _token: String = ""

func _init(domain: String = ""):
	_domain = domain

func _getHeader():
	return [
		"Content-Type: application/json",
		"Accept: application/json",
		"jwt: %s" % _token]

func _getQuery(query, key, entry):
	var prefix = ("&" if query else "?")
	return "%s%s=%s" % [prefix, key, str(entry)]

func _getUrl(endpoint: String, params: Dictionary, queries: Dictionary):
	var query = ""
	for key in queries:
		if typeof(queries[key]) == TYPE_ARRAY:
			for entry in queries[key]:
				query += _getQuery(query, key, entry)
		else:
			query += _getQuery(query, key, queries[key])
	return "%s%s%s" % [_domain, endpoint.format(params), query]

func _createRequest(onSuccess: Callable, onError: Callable):
	var httpRequest = HTTPRequest.new()
	add_child(httpRequest)
	httpRequest.request_completed.connect(_on_request_completed.bind(httpRequest, onSuccess, onError))
	return httpRequest

func _on_request_completed(result, response_code, headers, body, httpRequest, onSuccess, onError):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		if onSuccess:
			onSuccess.call(json)
	elif onError:
		onError.call(response_code, body.get_string_from_utf8())
	httpRequest.queue_free()

func authenticate(token: String):
	_token = token

func requestGet(endpoint: String, params: Dictionary, queries: Dictionary, onSuccess: Callable, onError: Callable):
	_createRequest(onSuccess, onError).request(_getUrl(endpoint, params, queries), _getHeader(), HTTPClient.METHOD_GET)

func requestPost(endpoint: String, params: Dictionary, queries: Dictionary, body: Dictionary, onSuccess: Callable, onError: Callable):
	_createRequest(onSuccess, onError).request(_getUrl(endpoint, params, queries), _getHeader(), HTTPClient.METHOD_POST, JSON.stringify(body))

func requestPut(endpoint: String, params: Dictionary, queries: Dictionary, body: Dictionary, onSuccess: Callable, onError: Callable):
	_createRequest(onSuccess, onError).request(_getUrl(endpoint, params, queries), _getHeader(), HTTPClient.METHOD_PUT, JSON.stringify(body))

func requestDelete(endpoint: String, params: Dictionary, queries: Dictionary, onSuccess: Callable, onError: Callable):
	_createRequest(onSuccess, onError).request(_getUrl(endpoint, params, queries), _getHeader(), HTTPClient.METHOD_DELETE)
