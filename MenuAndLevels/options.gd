extends MenuButton
const menu_path = Constants.GET_SCENE.menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_save_button_down() -> void:
	Progress.save_progress("Bebra")
	pass


func _on_quit_button_down() -> void:
	SceneLoader.load_scene(menu_path)
	pass # Replace with function body.
