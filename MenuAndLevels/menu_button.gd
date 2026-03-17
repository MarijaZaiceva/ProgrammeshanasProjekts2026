extends Button
var opt: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opt = get_tree().get_nodes_in_group("Options")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		_on_button_down()


func _on_button_down() -> void:
	#opening da menu!!!!!!!
	change_vis()
	print ("Hi papa") # Replace with function body.


func _on_return_button_down() -> void:
	#closing it
	change_vis()
	print ("bye papa") 
	
func change_vis() -> void:
	for o in opt:
		o.visible = not o.visible
