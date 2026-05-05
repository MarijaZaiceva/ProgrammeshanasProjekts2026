extends Node2D

const menu_path = Constants.GET_SCENE.menu
@onready var a = $technicallyastronom
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loop()
	
func loop():
	while true:
		a.play("default")
		await get_tree().create_timer(2.0).timeout
		a.play("arab")
		await get_tree().create_timer(2.0).timeout
		a.play("merchant")
		await get_tree().create_timer(2.0).timeout
		a.play("scientist")
		await get_tree().create_timer(2.0).timeout


func _on_button_button_down() -> void:
	SceneLoader.load_scene(menu_path)
	pass # Replace with function body.
