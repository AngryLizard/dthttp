class_name DTEntity
extends Object

var entityRef: String = ""
var name: String = ""
var type: DTType = null
var ownerRefs: Array[String] = []
var attributes: Dictionary = {}

func _init(data: Dictionary):
	entityRef = data["entityRef"]
	name = data["name"]
	type = DTClient.get_type(data["typeReg"])
	for ownerRef in data["ownerRefs"]:
		ownerRefs.append(ownerRef)
	for attributeData in data["attributes"]:
		attributes[attributeData["propReg"]] = attributeData["propVal"]
