extends Node

var _assets = {}

func _ready():
	#_loadAssetsFromFolder(get_script().resource_path.get_base_dir() + "/../generated/resources/")
	pass
	
func add_asset(asset: DTAsset):
	if asset.path.is_empty():
		print("Attempted to add asset with empty path")
		return
		
	print("Added asset %s" % [asset.path])
	_assets[asset.path] = asset
	
func add_assets(assets: Array):
	for asset in assets:
		add_asset(asset as DTAsset)

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
				add_asset(asset)
		filename = dir.get_next()
	dir.list_dir_end()

func get_asset(path: String):
	return _assets[path] if path in _assets else null

enum Test {
	BLAH,
	COOCOO
}
