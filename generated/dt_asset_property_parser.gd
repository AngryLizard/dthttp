
class_name DTAssetPropertyParser
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
