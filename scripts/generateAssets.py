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

files = glob.glob(os.path.join(targetPath, "assets/*"))
for f in files:
	os.remove(f)

files = glob.glob(os.path.join(targetPath, "resources/*"))
for f in files:
	os.remove(f)

if not os.path.exists(sourcePath):
	sys.exit(f'Source path /"{sourcePath}/" not found')

sourceFile = open(sourcePath)
sourceJson = json.load(sourceFile)

def sanitizeName(name):
	if len(name) == 0: return ""
	return name[0].upper() + name[1:]

# Print asset resources
for asset in sourceJson['assets']:
	uid = uuid.uuid4().hex[:12]
	ext = uuid.uuid4().hex[:5]
	type = asset['type']
	snake = snake_case(type)
	path = asset['path']
	assetsData = f'''
[gd_resource type="Resource" script_class="DT{type}Asset" load_steps=2 format=3 uid="uid://{uid}"]

[ext_resource type="Script" path="res://addons/dthttp/generated/assets/dt_{snake}_asset.gd" id="1_{ext}"]

[resource]
script = ExtResource("1_{ext}")
path = "{path}"
'''

	filename = "_".join(path.split("."))
	assetsTargetPath = os.path.join(targetPath, f"resources/{filename}.tres")
	f = open(assetsTargetPath, "w")
	f.write(assetsData)
	f.close()
	print(f'Generated assets to {assetsTargetPath}')

# Print asset types
for type in sourceJson['types']:
	snake = snake_case(type)
	assetsDefinition = f'''
class_name DT{type}Asset
extends DTAsset
'''

	assetsTargetPath = os.path.join(targetPath, f"assets/dt_{snake}_asset.gd")
	f = open(assetsTargetPath, "w")
	f.write(assetsDefinition)
	f.close()
	print(f'Generated assets to {assetsTargetPath}')
	
# Print asset properties
assetsProps = f'''
class_name DTAssetProperty
extends Object
'''
for type in sourceJson['types']:
	assetsProps += f'''
static func propValTo{type}(string: String) -> DT{type}Asset:
	return DTAssetLoader.getAsset(string) as DT{type}Asset
'''

assetsProps += f'''
static func addAssetTypes(plugin: EditorPlugin):'''
for type in sourceJson['types']:
	snake = snake_case(type)
	assetsProps += f'''
	plugin.add_custom_type("DT{type}Asset", "Resource", preload("assets/dt_{snake}_asset.gd"), null)'''

assetsProps += f'''

static func removeAssetTypes(plugin: EditorPlugin):'''
for type in sourceJson['types']:
	assetsProps += f'''
	plugin.remove_custom_type("DT{type}Asset")'''

assetsTargetPath = os.path.join(targetPath, f"dt_asset_property.gd")
f = open(assetsTargetPath, "w")
f.write(assetsProps)
f.close()
print(f'Generated asset properties to {assetsTargetPath}')
