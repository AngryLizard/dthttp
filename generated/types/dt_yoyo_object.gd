
class_name DTYoyoObject
extends DTCharacterObject

func _push_property_change(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	return super._push_property_change(propReg, propVal, timestamp, duration)

func _push_attribute_value(propReg: String, propVal: String) -> bool:
	return super._push_attribute_value(propReg, propVal)

func _get_type() -> String:
	return "Yoyo"

func _ready():
	pass