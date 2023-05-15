
class_name DTCharacterObject
extends DTActorObject

var _healthProperty: DTTimeline

## Get the value of the health property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the health property:
##  previous: health property value before current value
##  value: Current/last health property value
##  alpha: Lerp ratio between previous and current health property value
func getHealth(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _healthProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

var _meshProperty: DTTimeline

## Get the value of the mesh property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the mesh property:
##  previous: mesh property value before current value
##  value: Current/last mesh property value
##  alpha: Lerp ratio between previous and current mesh property value
func getMesh(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _meshProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

func _pushPropertyChange(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	if propReg == "health":
		_healthProperty.push(DTProperty.propValToFloat(propVal), timestamp, duration)
		return true;
	if propReg == "mesh":
		_meshProperty.push(DTProperty.propValToSkeletalMeshAsset(propVal), timestamp, duration)
		return true;
	return super._pushPropertyChange(propReg, propVal, timestamp, duration)

func _pushAttributeValue(propReg: String, propVal: String) -> bool:
	return super._pushAttributeValue(propReg, propVal)

func _getType() -> String:
	return "Character"

func _ready():
	_healthProperty = DTTimeline.new(DTProperty.propValToFloat("100"))
	_meshProperty = DTTimeline.new(DTProperty.propValToSkeletalMeshAsset(""))
