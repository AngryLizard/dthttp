class_name DTBaseObject
extends Node

func _pushPropertyChange(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	return false

func pushPropertyChange(change: Dictionary) -> bool:
	return _pushPropertyChange(change["PropReg"], change["PropVal"],
		DTKeyframe.stringToTimestamp(change["Timestamp"]),
		change["Duration"] as float)
	
func _pushAttributeValue(propReg: String, propVal: String) -> bool:
	return false

func pushAttributeValue(value: Dictionary) -> bool:
	return _pushAttributeValue(value["PropReg"], value["PropVal"])

func _getType() -> String:
	return "Base"

