extends Node2D

const level_path = Constants.GET_SCENE.level1
const secret_shit = Constants.GET_SCENE.secret
# Called when the node enters the scene tree for the first time.

func _on_texture_button_button_down() -> void:
	SceneLoader.load_scene(level_path)


func _on_button_button_down() -> void:
	SceneLoader.load_scene(secret_shit)
	pass # Replace with function body.
