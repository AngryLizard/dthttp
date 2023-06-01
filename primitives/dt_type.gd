class_name DTType
extends Object

var typeReg: String = ""
var asset: DTFactoryAsset = null
var parent: String = ""
var desc: String = ""
var props: Dictionary = {}
var attrs: Dictionary = {}

func _init(data: Dictionary):
	typeReg = data["typeReg"]
	asset = DTAssetPropertyParser.propValToFactory(data["asset"])
	parent = data["parent"]
	desc = data["desc"]
	for propData in data["props"]:
		props[propData["propReg"]] = DTDescriptor.new(propData)
	for attrData in data["attrs"]:
		attrs[attrData["propReg"]] = DTDescriptor.new(attrData)
