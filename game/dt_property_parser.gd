class_name DTPropertyParser
extends DTAssetPropertyParser

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

static func propValToFactory(string: String) -> DTFactoryAsset:
	return DTAssetLoader.getAsset(string) as DTFactoryAsset

static func propValToLevel(string: String) -> DTLevelAsset:
	return DTAssetLoader.getAsset(string) as DTLevelAsset

static func propValToActor(string: String) -> DTActorAsset:
	return DTAssetLoader.getAsset(string) as DTActorAsset

static func propValToStaticMesh(string: String) -> DTStaticMeshAsset:
	return DTAssetLoader.getAsset(string) as DTStaticMeshAsset

static func propValToSkeletalMesh(string: String) -> DTSkeletalMeshAsset:
	return DTAssetLoader.getAsset(string) as DTSkeletalMeshAsset

static func propValToTexture(string: String) -> DTTextureAsset:
	return DTAssetLoader.getAsset(string) as DTTextureAsset

static func propValToAnimation(string: String) -> DTAnimationAsset:
	return DTAssetLoader.getAsset(string) as DTAnimationAsset
