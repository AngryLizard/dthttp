class_name DTTimeline
extends Object

var _default: DTKeyframe = null
var _keyframes: Array[DTKeyframe] = []

func _init(default: Variant = null):
	_default = DTKeyframe.new(default, 0, 1.0)

## Add a value change to this timeline
func push(value: Variant, timestamp: int, duration: float):
	# Filter keyframes that were after the incoming timestamp
	# TODO: It shouldn't ever happen, but if keyframes ever come in out of 
	#       order this will delete keyframes. Instead we could update the list.
	_keyframes = _keyframes.filter(func(keyframe): return keyframe.idBefore(timestamp))
	
	## Add to the end of timeline
	var keyframe = DTKeyframe.new(value, timestamp, duration)
	keyframe._previous = _keyframes.back().getValue()
	_keyframes.append(keyframe)
	
	# TODO: Remove keyframes from the start so it doesn't grow into infinity

## Get keyframe that's relevant to a given timestamp
func peek(timestamp: int) -> DTKeyframe:
	for keyframe in _keyframes:
		if keyframe.isBefore(timestamp):
			return keyframe
	return _default
