
class_name DTEntityObject
extends DTBaseObject

var _displayNameProperty: DTTimeline

## Get the value of the displayName property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the displayName property:
##  previous: displayName property value before current value
##  value: Current/last displayName property value
##  alpha: Lerp ratio between previous and current displayName property value
func prop_get_display_name(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _displayNameProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

var _parentProperty: DTTimeline

## Get the value of the parent property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the parent property:
##  previous: parent property value before current value
##  value: Current/last parent property value
##  alpha: Lerp ratio between previous and current parent property value
func prop_get_parent(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _parentProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

var _sceneProperty: DTTimeline

## Get the value of the scene property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the scene property:
##  previous: scene property value before current value
##  value: Current/last scene property value
##  alpha: Lerp ratio between previous and current scene property value
func prop_get_scene(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _sceneProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

func _push_property_change(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	if propReg == "displayName":
		_displayNameProperty.push(DTPropertyParser.propValToString(propVal), timestamp, duration)
		return true;
	if propReg == "parent":
		_parentProperty.push(DTPropertyParser.propValToEntityRef(propVal), timestamp, duration)
		return true;
	if propReg == "scene":
		_sceneProperty.push(DTPropertyParser.propValToSceneReg(propVal), timestamp, duration)
		return true;
	return super._push_property_change(propReg, propVal, timestamp, duration)

func _push_attribute_value(propReg: String, propVal: String) -> bool:
	return super._push_attribute_value(propReg, propVal)

func _get_type() -> String:
	return "Entity"

func _ready():
	_displayNameProperty = DTTimeline.new(DTPropertyParser.propValToString(""))
	_parentProperty = DTTimeline.new(DTPropertyParser.propValToEntityRef(""))
	_sceneProperty = DTTimeline.new(DTPropertyParser.propValToSceneReg(""))