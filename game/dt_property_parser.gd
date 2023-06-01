class_name DTPropertyParser
extends DTAssetPropertyParser

static func prop_val_to_string(string: String) -> String:
	return string

static func prop_val_to_bool(string: String) -> bool:
	return string == "true" or string == "t" or string == "1"

static func prop_val_to_float(string: String) -> float:
	return float(string)

static func prop_val_to_sceneReg(string: String) -> DTSceneReg:
	var property = DTSceneReg.new()
	property.reg = string
	return property

static func prop_val_to_entityRef(string: String) -> DTEntityRef:
	var property = DTEntityRef.new()
	property.ref = string
	return property

static func prop_val_to_transform(string: String) -> DTTransform:
	var numbers = string.replace("(", "").replace(")", "").split_floats(",")
	var property = DTTransform.new()
	property.x = numbers[0]
	property.y = numbers[1]
	property.r = numbers[2]
	return property

static func prop_val_to_bool_array(string: String) -> Array[bool]:
	var strings: Array[String] = string.replace("[", "").replace("]", "").split(",")
	return strings.map(func (string): prop_val_to_bool(string))

static func prop_val_to_float_array(string: String) -> Array[float]:
	var strings = string.replace("[", "").replace("]", "").split(",")
	return strings.map(func (string): prop_val_to_float(string))

static func prop_val_to_string_array(string: String) -> Array[String]:
	var strings = string.replace("[", "").replace("]", "").split(",")
	return strings.map(func (string): prop_val_to_string(string))
	
static func prop_val_to_type(string: String) -> String:
	return string
