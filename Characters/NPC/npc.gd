extends CharacterBody3D
enum States {IDLE,PLAYERNEAR}
var stateRN = States.IDLE
@onready var instruction = $Label3D
var visible_instruction: bool = false
var first_line_id
var player: Node = null
const radius := 20
const character_name: String = "čau brāl"

func _ready() -> void:
	if get_tree().get_nodes_in_group("Player")[0]:
		player = get_tree().get_nodes_in_group("Player")[0]
	instruction.set_visible(false)
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("interract") and _player_near():
		DialoguePlayer.start_talking_with_(character_name)
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
