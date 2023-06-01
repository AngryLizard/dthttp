@tool
extends EditorPlugin
class_name DTHttp

func _enter_tree():
	add_custom_type("DTFactoryAsset", "Resource", preload("assets/dt_factory_asset.gd"), null)
	add_custom_type("DTLevelAsset", "Resource", preload("assets/dt_level_asset.gd"), null)
	add_custom_type("DTActorAsset", "Resource", preload("assets/dt_actor_asset.gd"), null)
	add_custom_type("DTStaticMeshAsset", "Resource", preload("assets/dt_static_mesh_asset.gd"), null)
	add_custom_type("DTSkeletalMeshAsset", "Resource", preload("assets/dt_skeletal_mesh_asset.gd"), null)
	add_custom_type("DTTextureAsset", "Resource", preload("assets/dt_texture_asset.gd"), null)
	add_custom_type("DTAnimationAsset", "Resource", preload("assets/dt_animation_asset.gd"), null)
	add_autoload_singleton("DTAssetLoader", get_script().resource_path.get_base_dir() + "/game/dt_asset_loader.gd")
	add_autoload_singleton("DTClient", get_script().resource_path.get_base_dir() + "/dt_client.gd")

func _exit_tree():
	remove_autoload_singleton("DTClient")
	remove_autoload_singleton("DTAssetLoader")
	remove_custom_type("DTFactoryAsset")
	remove_custom_type("DTLevelAsset")
	remove_custom_type("DTActorAsset")
	remove_custom_type("DTStaticMeshAsset")
	remove_custom_type("DTSkeletalMeshAsset")
	remove_custom_type("DTTextureAsset")
	remove_custom_type("DTAnimationAsset")
