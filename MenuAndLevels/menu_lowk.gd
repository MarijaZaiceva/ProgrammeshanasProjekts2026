extends Node2D

const level_path = Constants.GET_SCENE.level1
# Called when the node enters the scene tree for the first time.

func _on_texture_button_button_down() -> void:
	SceneLoader.load_scene(level_path)


func _on_button_button_down() -> void:
	pass # Replace with function body.
