extends CharacterBody3D
enum States {IDLE,PLAYERNEAR}
var stateRN = States.IDLE
@onready var instruction = $Label3D
var visible_instruction: bool = false
var first_line_id
var player: Node = null
const radius = 20

func _ready() -> void:
	if get_tree().get_current_scene().has_node("Level1/Player"):
		player = get_tree().get_current_scene().get_node("Level1/Player")
	instruction.set_visible(false)
	
func _physics_process(delta: float) -> void:
	match stateRN:
		States.IDLE:
			if _player_near() and not visible_instruction:
				instruction.set_visible(true)
				stateRN=States.PLAYERNEAR
				visible_instruction = true
		States.PLAYERNEAR:
			if visible_instruction and not _player_near():
				instruction.set_visible(false)
				stateRN=States.IDLE
				visible_instruction = false
#move_and_slide()
func _player_near() -> bool:
	return is_instance_valid(player) and global_position.distance_to(player.global_position) <= radius
