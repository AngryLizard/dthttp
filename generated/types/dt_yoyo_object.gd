
class_name DTYoyoObject
extends DTCharacterObject

func _pushPropertyChange(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	return super._pushPropertyChange(propReg, propVal, timestamp, duration)

func _pushAttributeValue(propReg: String, propVal: String) -> bool:
	return super._pushAttributeValue(propReg, propVal)

func _getType() -> String:
	return "Yoyo"

func _ready():
	pass