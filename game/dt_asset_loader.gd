class_name DTAssetLoader
extends Node

var _assets = {}

func _ready():
	load_assets_from_folder(get_script().resource_path.get_base_dir() + "/../generated/resources/")

func load_assets_from_folder(folder_path: String) -> void:
	var dir = DirAccess.open(folder_path)
	dir.list_dir_begin()
	var filename = dir.get_next()
	while filename != "":
		if dir.current_is_dir():
			pass
		else:
			var path = folder_path + filename
			var asset = load(path) as DTAsset
			if asset:
				print("Loaded asset %s" % [asset.path])
				_assets[asset.path] = asset
		filename = dir.get_next()
	dir.list_dir_end()

func getAsset(path: String):
	var assetLoader = get_tree().get_root().get_node("dt_asset_loader")
	return assetLoader._assets[path] if path in assetLoader._assets else null
