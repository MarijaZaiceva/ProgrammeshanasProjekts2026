extends Node2D
const menu_path = Constants.GET_SCENE.menu
var player_data : Panel = null
var error_area : Label = null

func _ready() -> void:
	player_data = self.find_child("PlayerData")
	error_area = self.find_child("Error")
	

func _on_process_input_button_down() -> void:
	if player_data.valid():
		SceneLoader.load_scene(menu_path)
	else:
		error_area.visible=true
		error_area.text = player_data.error()
	pass # Replace with function body.
	
