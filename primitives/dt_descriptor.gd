class_name DTDescriptor
extends Object

var desc: String
var type: String
var initial: String

func _init(data):
	desc = data["desc"]
	type = data["type"]
	initial = data["initial"]
