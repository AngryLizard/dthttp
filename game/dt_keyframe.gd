class_name DTKeyframe
extends Object

var _value: Variant
var _previous: Variant
var _timestamp: int
var _duration: float

func _init(value: Variant = null, timestamp: int = 0, duration: float = 1.0):
	_value = value
	_timestamp = timestamp
	_duration = duration

func isBefore(timestamp: int):
	return _timestamp < timestamp

## Get value of this keyframe
func getValue():
	return _value

## Get previous value of this keyframe
func getPrevious():
	return _previous

## Get alpha lerp value between this keyframe and timestamp
func getAlpha(timestamp: int) -> float:
	if _duration < 0.001:
		return 1.0 if timestamp > _timestamp else 0.0
	return clamp((timestamp - _timestamp) * (1000.0 / _duration), 0.0, 1.0);

## Convert datetime string to milliseconds integer
static func stringToTimestamp(dateTime: String) -> int:
	var split = dateTime.split(".")
	var seconds = Time.get_unix_time_from_datetime_string(split[0])
	var milliseconds = int(split[1])
	return seconds * 1000 + milliseconds
