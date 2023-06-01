class_name DTBaseObject
extends Object

func _push_property_change(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	return false

func push_property_change(change: Dictionary) -> bool:
	return _push_property_change(change["PropReg"], change["PropVal"],
		DTKeyframe.stringToTimestamp(change["Timestamp"]),
		change["Duration"] as float)
	
func _push_attribute_value(propReg: String, propVal: String) -> bool:
	return false

func push_attribute_value(value: Dictionary) -> bool:
	return _push_attribute_value(value["PropReg"], value["PropVal"])

func _get_type() -> String:
	return "Base"

