
class_name DTAssetRegister
extends Node

@export
var factoryAssets: Array[DTFactoryAsset] = [
	preload("resources/type_factory_world.tres"),
	preload("resources/type_factory_character.tres")]

@export
var levelAssets: Array[DTLevelAsset] = [
	preload("resources/type_entity_world_testLevel.tres")]

@export
var actorAssets: Array[DTActorAsset] = [
	preload("resources/type_entity_actor_box.tres"),
	preload("resources/type_entity_actor_character__.tres"),
	preload("resources/type_entity_actor_character_yoyo.tres"),
	preload("resources/type_entity_actor_character_kirin.tres")]

@export
var staticMeshAssets: Array[DTStaticMeshAsset] = []

@export
var skeletalMeshAssets: Array[DTSkeletalMeshAsset] = [
	preload("resources/type_mesh_characterMesh.tres")]

@export
var textureAssets: Array[DTTextureAsset] = []

@export
var animationAssets: Array[DTAnimationAsset] = []

func _ready():
	DTAssetLoader.addAssets(factoryAssets)
	DTAssetLoader.addAssets(levelAssets)
	DTAssetLoader.addAssets(actorAssets)
	DTAssetLoader.addAssets(staticMeshAssets)
	DTAssetLoader.addAssets(skeletalMeshAssets)
	DTAssetLoader.addAssets(textureAssets)
	DTAssetLoader.addAssets(animationAssets)
