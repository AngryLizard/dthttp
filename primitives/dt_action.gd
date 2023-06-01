class_name DTAction
extends Object

var actionReg: String = ""
var domain: String = ""
var trigger: String = ""
var desc: String = ""
var params: Dictionary = {}

func _init(data: Dictionary):
	actionReg = data["actionReg"]
	domain = data["domain"]
	trigger = data["trigger"]
	desc = data["desc"]
	for paramData in data["params"]:
		params[paramData["paramReg"]] = DTParameter.new(paramData)
