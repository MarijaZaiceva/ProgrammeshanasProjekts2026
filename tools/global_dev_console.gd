extends Node
const menu_path = Constants.GET_SCENE.menu
const level_path = Constants.GET_SCENE.level1
const repeat = 50

func _ready() -> void:
	pass

		
func loaderdose () ->void:
	for i in repeat:
		SceneLoader.load_scene(menu_path)
		SceneLoader.load_scene(level_path)
		if i==repeat:
			set_physics_process(false)
