
class_name DTSpawnerObject
extends DTActorObject

var _activeProperty: DTTimeline

## Get the value of the active property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the active property:
##  previous: active property value before current value
##  value: Current/last active property value
##  alpha: Lerp ratio between previous and current active property value
func getActive(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _activeProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

func _pushPropertyChange(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	if propReg == "active":
		_activeProperty.push(DTPropertyParser.propValToBool(propVal), timestamp, duration)
		return true;
	return super._pushPropertyChange(propReg, propVal, timestamp, duration)

func _pushAttributeValue(propReg: String, propVal: String) -> bool:
	return super._pushAttributeValue(propReg, propVal)

func _getType() -> String:
	return "Spawner"

func _ready():
	_activeProperty = DTTimeline.new(DTPropertyParser.propValToBool("true"))