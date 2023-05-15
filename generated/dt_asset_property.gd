
class_name DTAssetProperty
extends Object

static func propValToFactory(string: String) -> DTFactoryAsset:
	return DTAssetLoader.getAsset(string) as DTFactoryAsset

static func propValToLevel(string: String) -> DTLevelAsset:
	return DTAssetLoader.getAsset(string) as DTLevelAsset

static func propValToActor(string: String) -> DTActorAsset:
	return DTAssetLoader.getAsset(string) as DTActorAsset

static func propValToStaticMesh(string: String) -> DTStaticMeshAsset:
	return DTAssetLoader.getAsset(string) as DTStaticMeshAsset

static func propValToSkeletalMesh(string: String) -> DTSkeletalMeshAsset:
	return DTAssetLoader.getAsset(string) as DTSkeletalMeshAsset

static func propValToTexture(string: String) -> DTTextureAsset:
	return DTAssetLoader.getAsset(string) as DTTextureAsset

static func propValToAnimation(string: String) -> DTAnimationAsset:
	return DTAssetLoader.getAsset(string) as DTAnimationAsset

static func addAssetTypes(plugin: EditorPlugin):
	plugin.add_custom_type("DTFactoryAsset", "Resource", preload("assets/dt_factory_asset.gd"), null)
	plugin.add_custom_type("DTLevelAsset", "Resource", preload("assets/dt_level_asset.gd"), null)
	plugin.add_custom_type("DTActorAsset", "Resource", preload("assets/dt_actor_asset.gd"), null)
	plugin.add_custom_type("DTStaticMeshAsset", "Resource", preload("assets/dt_static_mesh_asset.gd"), null)
	plugin.add_custom_type("DTSkeletalMeshAsset", "Resource", preload("assets/dt_skeletal_mesh_asset.gd"), null)
	plugin.add_custom_type("DTTextureAsset", "Resource", preload("assets/dt_texture_asset.gd"), null)
	plugin.add_custom_type("DTAnimationAsset", "Resource", preload("assets/dt_animation_asset.gd"), null)

static func removeAssetTypes(plugin: EditorPlugin):
	plugin.remove_custom_type("DTFactoryAsset")
	plugin.remove_custom_type("DTLevelAsset")
	plugin.remove_custom_type("DTActorAsset")
	plugin.remove_custom_type("DTStaticMeshAsset")
	plugin.remove_custom_type("DTSkeletalMeshAsset")
	plugin.remove_custom_type("DTTextureAsset")
	plugin.remove_custom_type("DTAnimationAsset")
