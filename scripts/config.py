
## [C Type, C Setup Type, Copy-by-value]
typeAssignments = {
	"String":               ["String",                  "String"],
	"Boolean":              ["bool",                    "Bool"],
	"Number":               ["float",                   "Float"],
	"SceneReg":             ["DTSceneReg",              "SceneReg"],
	"EntityRef":            ["DTEntityRef",             "EntityRef"],
	"LevelAsset":           ["DTLevelAsset",           	"LevelAsset"],
	"ActorAsset":           ["DTActorAsset",           	"ActorAsset"],
	"StaticMeshAsset":      ["DTStaticMeshAsset",     	"StaticMeshAsset"],
	"SkeletalMeshAsset":    ["DTSkeletalMeshAsset",    	"SkeletalMeshAsset"],
	"TextureAsset":         ["DTTextureAsset",         	"TextureAsset"],
	"AnimationAsset":       ["DTAnimationAsset",       	"AnimationAsset"],
	"Transform":            ["DTTransform",             "Transform"],
	"BooleanArray":         ["Array[bool]",            	"BoolArray"],
	"NumberArray":          ["Array[float]",           	"FloatArray"],
	"StringArray":          ["Array[String]",           "StringArray"],
	"Type":                 ["String",                  "Type"],
}

dtHttpPath = "../NodeJS/Dragotheria-Server"

def getPropGType(prop):
	typeName = "String"
	if prop in typeAssignments:
		typeName = typeAssignments[prop][0]
	else:
		print(f'No Godot type for property {prop} defined, please add it to the config file. Defaulting to String.')
	return typeName

def getPropGName(prop):
	typeName = "DTString"
	if prop in typeAssignments:
		typeName = typeAssignments[prop][1]
	else:
		print(f'No Godot name for property {prop} defined, please add it to the config file. Defaulting to DTString.')
	return typeName