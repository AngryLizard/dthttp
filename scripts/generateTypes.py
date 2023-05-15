import json
import sys
import os
import glob

from config import getPropGType, getPropGName, dtHttpPath

dir_path = os.path.dirname(os.path.realpath(__file__))

sourcePath = os.path.join(dir_path, dtHttpPath, "build/generated", "types.json")
targetPath = os.path.join(dir_path, "../generated/types")

if not os.path.exists(sourcePath):
	sys.exit(f'Source path /"{sourcePath}/" not found')

files = glob.glob(os.path.join(targetPath, "*"))
for f in files:
	os.remove(f)

sourceFile = open(sourcePath)
sourceJson = json.load(sourceFile)

def sanitizeName(name):
	if len(name) == 0: return ""
	return name[0].upper() + name[1:]

# Print types
for type in sourceJson:
	typeKey = type['typeKey']
	parent = type['parent'] if type['parent'] else 'Base'

	objectsData = f'''
class_name DT{typeKey}Object
extends DT{parent}Object
'''


	# Write timeline properties
	for prop in type['props']:

		if prop['isPublic']:
			propKey = prop['propKey']
			objectsData += f'''
var _{propKey}Property: DTTimeline

## Get the value of the {propKey} property from this object at a given timestamp
## Returns an object with the information needed to lerp between previous and current
## value of the {propKey} property:
##  previous: {propKey} property value before current value
##  value: Current/last {propKey} property value
##  alpha: Lerp ratio between previous and current {propKey} property value
func get{sanitizeName(propKey)}(timestamp: int) -> Dictionary:
	var output = {{}}
	var keyframe = _{propKey}Property.peek(timestamp)
	output["alpha"] = keyframe.lerpTimestamp(timestamp)
	output["previous"] = keyframe.Previous
	output["value"] = keyframe.Value
	return output
'''
	# Write attributes
	for attr in type['attrs']:

		if attr['isPublic']:
			gType = getPropGType(attr['type'])
			propKey = attr['propKey']
			objectsData += f'''
var _{propKey}Attribute: {gType}

## Get the value of the {propKey} attribute from this object
func get{sanitizeName(propKey)}() -> {gType}:
	return _{propKey}Attribute
'''

	objectsData += f'''
func _pushPropertyChange(propReg: String, propVal: String, timestamp: int, duration: float) -> bool:'''

	# Write property switch for push
	for prop in type['props']:

		gName = getPropGName(prop['type'])
		propKey = prop['propKey']
		if prop['isPublic']:
			objectsData += f'''
	if propReg == "{prop['propKey']}":
		_{propKey}Property.push(DTProperty.propValTo{gName}(propVal), timestamp, duration)
		return true;'''

	objectsData += f'''
	return super._pushPropertyChange(propReg, propVal, timestamp, duration)
'''

	objectsData += f'''
func _pushAttributeValue(propReg: String, propVal: String) -> bool:'''

	# Write property switch for push
	for attr in type['attrs']:

		gName = getPropGName(attr['type'])
		propKey = attr['propKey']
		if attr['isPublic']:
			objectsData += f'''
	if propReg == "{attr['propKey']}":
		_{propKey}Attribute = DTProperty.propValTo{gName}(propVal)
		return true;'''

	objectsData += f'''
	return super._pushAttributeValue(propReg, propVal)
'''

	objectsData += f'''
func _getType() -> String:
	return "{type['typeKey']}"
'''
	
	objectsData += f'''
func _ready():'''

	hasEntry = False
	# Write timeline property defaults
	for prop in type['props']:

		if prop['isPublic']:
			hasEntry = True
			gType = getPropGType(prop['type'])
			gName = getPropGName(prop['type'])
			propKey = prop['propKey']
			objectsData += f'''
	_{propKey}Property = DTTimeline.new(DTProperty.propValTo{gName}("{prop['initial']}"))'''

	# Write attribute defaults
	for attr in type['attrs']:

		if attr['isPublic']:
			hasEntry = True
			gType = getPropGType(attr['type'])
			gName = getPropGName(attr['type'])
			propKey = attr['propKey']
			objectsData += f'''
	_{propKey}Attribute = DTProperty.propValTo{gName}("{attr['initial']}")'''

	if not hasEntry:
		objectsData += f'''
	pass'''

	objectsTargetPath = os.path.join(targetPath, f'dt_{typeKey.lower()}_object.gd')
	f = open(objectsTargetPath, "w")
	f.write(objectsData)
	f.close()

	print(f'Generated Objects to {objectsTargetPath}')