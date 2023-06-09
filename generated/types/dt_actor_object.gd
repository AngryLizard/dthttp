
class_name DTActorObject
extends DTEntityObject

var _transformProperty: DTTimeline

## Get the value of the transform property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the transform property:
##  previous: transform property value before current value
##  value: Current/last transform property value
##  alpha: Lerp ratio between previous and current transform property value
func prop_get_transform(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _transformProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

var _msgProperty: DTTimeline

## Get the value of the msg property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the msg property:
##  previous: msg property value before current value
##  value: Current/last msg property value
##  alpha: Lerp ratio between previous and current msg property value
func prop_get_msg(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _msgProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

var _actorAttribute: DTActorAsset

## Get the value of the actor attribute from this object
func attr_get_actor() -> DTActorAsset:
	return _actorAttribute

func _push_property_change(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	if propReg == "transform":
		_transformProperty.push(DTPropertyParser.propValToTransform(propVal), timestamp, duration)
		return true;
	if propReg == "msg":
		_msgProperty.push(DTPropertyParser.propValToString(propVal), timestamp, duration)
		return true;
	return super._push_property_change(propReg, propVal, timestamp, duration)

func _push_attribute_value(propReg: String, propVal: String) -> bool:
	if propReg == "actor":
		_actorAttribute = DTPropertyParser.propValToActorAsset(propVal)
		return true;
	return super._push_attribute_value(propReg, propVal)

func _get_type() -> String:
	return "Actor"

func _ready():
	_transformProperty = DTTimeline.new(DTPropertyParser.propValToTransform("(0, 0, 0)"))
	_msgProperty = DTTimeline.new(DTPropertyParser.propValToString(""))
	_actorAttribute = DTPropertyParser.propValToActorAsset("")