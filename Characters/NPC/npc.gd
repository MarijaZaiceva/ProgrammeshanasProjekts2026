extends CharacterBody3D
enum States {IDLE, SPEAKING}
var stateRN = States.IDLE

func _ready() -> void:
	match stateRN:
		States.IDLE:
			return
		States.SPEAKING:
			return
#move_and_slide()
