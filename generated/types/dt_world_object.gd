
class_name DTWorldObject
extends DTBaseObject

var _temperatureProperty: DTTimeline

## Get the value of the temperature property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the temperature property:
##  previous: temperature property value before current value
##  value: Current/last temperature property value
##  alpha: Lerp ratio between previous and current temperature property value
func getTemperature(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _temperatureProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

var _levelAttribute: DTLevelAsset

## Get the value of the level attribute from this object
func getLevel() -> DTLevelAsset:
	return _levelAttribute

func _pushPropertyChange(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	if propReg == "temperature":
		_temperatureProperty.push(DTPropertyParser.propValToFloat(propVal), timestamp, duration)
		return true;
	return super._pushPropertyChange(propReg, propVal, timestamp, duration)

func _pushAttributeValue(propReg: String, propVal: String) -> bool:
	if propReg == "level":
		_levelAttribute = DTPropertyParser.propValToLevelAsset(propVal)
		return true;
	return super._pushAttributeValue(propReg, propVal)

func _getType() -> String:
	return "World"

func _ready():
	_temperatureProperty = DTTimeline.new(DTPropertyParser.propValToFloat(""))
	_levelAttribute = DTPropertyParser.propValToLevelAsset("")