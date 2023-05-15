@tool
extends EditorPlugin
class_name DTHttp

func _enter_tree():
	DTAssetProperty.addAssetTypes(self)
	add_autoload_singleton("DTAssetLoader", get_script().resource_path.get_base_dir() + "/game/dt_asset_loader.gd")

func _exit_tree():
	remove_autoload_singleton("DTAssetLoader")
	DTAssetProperty.removeAssetTypes(self)
