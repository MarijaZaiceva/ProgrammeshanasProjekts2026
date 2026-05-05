extends MenuButton
const menu_path = Constants.GET_SCENE.menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.create_choice.connect(create_that_choice)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_opt_1_button_down() -> void:
	respond(1)


func _on_opt_2_button_down() -> void:
	respond(2)


func _on_opt_3_button_down() -> void:
	respond(3)


func respond(id)->void:
	SignalBus.emit_signal("made_choice", id)
	visible = false
	
	
func create_that_choice(cru, opt1, opt2, opt3)->void:
	var buttons: Array =get_tree().get_nodes_in_group("DialOptions")
	
	for n in buttons:
		buttons[0].text = opt1
		buttons[1].text = opt2
		buttons[2].text = opt3
		
	visible = true
