extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"../Player".get_position_delta($"../MonsterThing")<2:
		print($"../Player".get_position_delta())
		show()
	pass
