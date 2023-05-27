extends Node

var _assets = {}

func _ready():
	#_loadAssetsFromFolder(get_script().resource_path.get_base_dir() + "/../generated/resources/")
	pass
	
func addAsset(asset: DTAsset):
	if asset.path.is_empty():
		print("Attempted to add asset with empty path")
		return
		
	print("Added asset %s" % [asset.path])
	_assets[asset.path] = asset
	
func addAssets(assets: Array):
	for asset in assets:
		addAsset(asset as DTAsset)

func loadAssetsFromFolder(folder_path: String) -> void:
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
				addAsset(asset)
		filename = dir.get_next()
	dir.list_dir_end()

func getAsset(path: String):
	return _assets[path] if path in _assets else null
