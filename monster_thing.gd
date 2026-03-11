extends CharacterBody3D

var spawn_position: Vector3
var direction: Vector3 = Vector3.ZERO
enum State { WANDER, CHASE, ATTACK }
var goal: Node = null
var attack_timer: float = 0.0

func _ready():
	spawn_position = global_position
	#state_machine = anim_tree.get("parameters/playback")

	if get_tree().get_current_scene().has_node("Level1/Player"):
		goal = get_tree().get_current_scene().get_node("Level1/Player")
		
	_pick_new_wander_target()
	
func _physics_process(delta: float) -> void:
	if not goal:
		return
	if attack_timer > 0:
		attack_timer-=delta
	pass
	
func _pick_new_wander_target():
	pass
