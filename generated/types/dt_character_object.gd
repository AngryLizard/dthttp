
class_name DTCharacterObject
extends DTActorObject

var _healthProperty: DTTimeline

## Get the value of the health property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the health property:
##  previous: health property value before current value
##  value: Current/last health property value
##  alpha: Lerp ratio between previous and current health property value
func prop_get_health(timestamp: int) -> Dictionary:
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
func prop_get_mesh(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _meshProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

func _push_property_change(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	if propReg == "health":
		_healthProperty.push(DTPropertyParser.propValToFloat(propVal), timestamp, duration)
		return true;
	if propReg == "mesh":
		_meshProperty.push(DTPropertyParser.propValToSkeletalMeshAsset(propVal), timestamp, duration)
		return true;
	return super._push_property_change(propReg, propVal, timestamp, duration)

func _push_attribute_value(propReg: String, propVal: String) -> bool:
	return super._push_attribute_value(propReg, propVal)

func _get_type() -> String:
	return "Character"

func _ready():
	_healthProperty = DTTimeline.new(DTPropertyParser.propValToFloat("100"))
	_meshProperty = DTTimeline.new(DTPropertyParser.propValToSkeletalMeshAsset(""))