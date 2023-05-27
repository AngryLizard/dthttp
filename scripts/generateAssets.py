import json
import sys
import os
import glob
import uuid
from re import sub

from config import dtHttpPath

def snake_case(s):
	return '_'.join(
		sub('([A-Z][a-z]+)', r' \1',
		sub('([A-Z]+)', r' \1',
		s.replace('-', ' '))).split()).lower()

dir_path = os.path.dirname(os.path.realpath(__file__))

sourcePath = os.path.join(dir_path, dtHttpPath, "build/generated", "assets.json")
targetPath = os.path.join(dir_path, "../generated")

if not os.path.exists(sourcePath):
	sys.exit(f'Source path /"{sourcePath}/" not found')

sourceFile = open(sourcePath)
sourceJson = json.load(sourceFile)

def sanitizeName(name):
	if len(name) == 0: return ""
	return name[0].upper() + name[1:]

def lowercaseName(name):
	if len(name) == 0: return ""
	return name[0].lower() + name[1:]

def makeResourcePath(path):
	joined = "_".join(path.split("."))
	return f"resources/{joined}.tres"

assetPaths = {}

# Print asset resources
for asset in sourceJson['assets']:
	uid = uuid.uuid4().hex[:12]
	ext = uuid.uuid4().hex[:5]
	type = asset['type']
	snake = snake_case(type)
	path = asset['path']

	if not type in assetPaths:
		assetPaths[type] = []
	assetPaths[type].append(path)

	assetsData = f'''
[gd_resource type="Resource" script_class="DT{type}Asset" load_steps=2 format=3 uid="uid://{uid}"]

[ext_resource type="Script" path="res://addons/dthttp/assets/dt_{snake}_asset.gd" id="1_{ext}"]

[resource]
script = ExtResource("1_{ext}")
path = "{path}"
'''

	resourcePath = makeResourcePath(path)
	assetsTargetPath = os.path.join(targetPath, resourcePath)
	# Do not recreate if already exists. This is the only resource that will have userdata 
	# and the name directly corresponds with the generated part, which is the path.
	if not os.path.exists(assetsTargetPath):
		f = open(assetsTargetPath, "w")
		f.write(assetsData)
		f.close()
		print(f'Generated assets to {assetsTargetPath}')
	
# Print asset properties
assetsProps = f'''
class_name DTAssetPropertyParser
extends Object
'''
for type in sourceJson['types']:
	assetsProps += f'''
static func propValTo{type}(string: String) -> DT{type}Asset:
	return DTAssetLoader.getAsset(string) as DT{type}Asset
'''

assetsTargetPath = os.path.join(targetPath, f"dt_asset_property_parser.gd")
f = open(assetsTargetPath, "w")
f.write(assetsProps)
f.close()
print(f'Generated asset properties to {assetsTargetPath}')

# Print asset properties
assetsRegister = f'''
class_name DTAssetRegister
extends Node
'''

for type in sourceJson['types']:

	resources = []
	if type in assetPaths:
		for path in assetPaths[type]:
			resourcePath = makeResourcePath(path)
			resources.append(f'preload("{resourcePath}")')
	resourcesString = (f'\n\t' + f',\n\t'.join(resources)) if resources else ""
	assetsRegister += f'''
@export
var {lowercaseName(type)}Assets: Array[DT{type}Asset] = [{resourcesString}]
'''

assetsRegister += f'''
func _ready():'''
for type in sourceJson['types']:
	assetsRegister += f'''
	DTAssetLoader.addAssets({lowercaseName(type)}Assets)'''

assetsTargetPath = os.path.join(targetPath, f"dt_asset_register.gd")
f = open(assetsTargetPath, "w")
f.write(assetsRegister)
f.close()
print(f'Generated asset properties to {assetsTargetPath}')