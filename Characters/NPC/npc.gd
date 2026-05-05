class_name Npc extends StaticBody3D

@onready var instruction = $Label3D
@onready var player:= get_tree().get_nodes_in_group("Player")[0]

enum States {IDLE,PLAYERNEAR}

var stateRN = States.IDLE
var visible_instruction: bool = false
@export var character_name: String = "npc"
@export var dialID: int = 1
@export var chronology: Array[int] = [1,2,3]
const radius := 40

func _ready() -> void:
	instruction.set_visible(false)
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("interract") and _player_near():
		DialoguePlayer.start_talking_(dialID)
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
