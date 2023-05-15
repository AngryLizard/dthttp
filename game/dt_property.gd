class_name DTProperty
extends DTAssetProperty

static func propValToString(string: String) -> String:
	return string

static func propValToBool(string: String) -> bool:
	return string == "true" or string == "t" or string == "1"

static func propValToFloat(string: String) -> float:
	return float(string)

static func propValToSceneReg(string: String) -> DTSceneReg:
	var property = DTSceneReg.new()
	property.reg = string
	return property

static func propValToEntityRef(string: String) -> DTEntityRef:
	var property = DTEntityRef.new()
	property.ref = string
	return property

static func propValToTransform(string: String) -> DTTransform:
	var numbers = string.replace("(", "").replace(")", "").split_floats(",")
	var property = DTTransform.new()
	property.x = numbers[0]
	property.y = numbers[1]
	property.r = numbers[2]
	return property

static func propValToBoolArray(string: String) -> Array[bool]:
	var strings: Array[String] = string.replace("[", "").replace("]", "").split(",")
	return strings.map(func (string): propValToBool(string))

static func propValToFloatArray(string: String) -> Array[float]:
	var strings = string.replace("[", "").replace("]", "").split(",")
	return strings.map(func (string): propValToFloat(string))

static func propValToStringArray(string: String) -> Array[String]:
	var strings = string.replace("[", "").replace("]", "").split(",")
	return strings.map(func (string): propValToString(string))
	
static func propValToType(string: String) -> String:
	return string
