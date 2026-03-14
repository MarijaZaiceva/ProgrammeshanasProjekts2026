extends Node2D
const menu_path = Constants.GET_SCENE.menu


func _on_process_input_button_down() -> void:
	SceneLoader.load_scene(menu_path)
	pass # Replace with function body.
