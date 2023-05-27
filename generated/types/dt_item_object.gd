
class_name DTItemObject
extends DTActorObject

var _weightProperty: DTTimeline

## Get the value of the weight property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the weight property:
##  previous: weight property value before current value
##  value: Current/last weight property value
##  alpha: Lerp ratio between previous and current weight property value
func getWeight(timestamp: int) -> Dictionary:
	var output = {}
	var keyframe = _weightProperty.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output

func _pushPropertyChange(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:
	if propReg == "weight":
		_weightProperty.push(DTPropertyParser.propValToFloat(propVal), timestamp, duration)
		return true;
	return super._pushPropertyChange(propReg, propVal, timestamp, duration)

func _pushAttributeValue(propReg: String, propVal: String) -> bool:
	return super._pushAttributeValue(propReg, propVal)

func _getType() -> String:
	return "Item"

func _ready():
	_weightProperty = DTTimeline.new(DTPropertyParser.propValToFloat("10"))