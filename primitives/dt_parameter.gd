class_name DTParameter
extends DTDescriptor

var input: String

func _init(data):
	super._init(data)
	input = data["input"]
