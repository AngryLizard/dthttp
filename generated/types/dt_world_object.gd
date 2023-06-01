
class_name DTWorldObject
extends DTBaseObject

var _temperatureProperty: DTTimeline

## Get the value of the temperature property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the temperature property:
##  previous: temperature property value before current value
##  value: Current/last temperature property value
##  alpha: Lerp ratio between previous and current temperature property value
func prop_get_temperature(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _temperatureProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

var _levelAttribute: DTLevelAsset

## Get the value of the level attribute from this object
func attr_get_level() -> DTLevelAsset:
	return _levelAttribute

func _push_property_change(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	if propReg == "temperature":
		_temperatureProperty.push(DTPropertyParser.propValToFloat(propVal), timestamp, duration)
		return true;
	return super._push_property_change(propReg, propVal, timestamp, duration)

func _push_attribute_value(propReg: String, propVal: String) -> bool:
	if propReg == "level":
		_levelAttribute = DTPropertyParser.propValToLevelAsset(propVal)
		return true;
	return super._push_attribute_value(propReg, propVal)

func _get_type() -> String:
	return "World"

func _ready():
	_temperatureProperty = DTTimeline.new(DTPropertyParser.propValToFloat(""))
	_levelAttribute = DTPropertyParser.propValToLevelAsset("")