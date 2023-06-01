
class_name DTAssetPropertyParser
extends Object

static func prop_val_to_factory(string: String) -> DTFactoryAsset:
	return DTAssetLoader.getAsset(string) as DTFactoryAsset

static func prop_val_to_level(string: String) -> DTLevelAsset:
	return DTAssetLoader.getAsset(string) as DTLevelAsset

static func prop_val_to_actor(string: String) -> DTActorAsset:
	return DTAssetLoader.getAsset(string) as DTActorAsset

static func prop_val_to_static_mesh(string: String) -> DTStaticMeshAsset:
	return DTAssetLoader.getAsset(string) as DTStaticMeshAsset

static func prop_val_to_skeletal_mesh(string: String) -> DTSkeletalMeshAsset:
	return DTAssetLoader.getAsset(string) as DTSkeletalMeshAsset

static func prop_val_to_texture(string: String) -> DTTextureAsset:
	return DTAssetLoader.getAsset(string) as DTTextureAsset

static func prop_val_to_animation(string: String) -> DTAnimationAsset:
	return DTAssetLoader.getAsset(string) as DTAnimationAsset
