extends CharacterBody3D

var spawn_position: Vector3
var direction: Vector3 = Vector3.ZERO
enum States { WANDER, CHASE, ATTACK }
var stateRN: States = States.WANDER
var goal: Node = null
var attack_timer: float = 0.0
var attacking: bool = false
const detection_radius = 300.0
const attack_range = 100.0
const wander_radius = 200
var agent: NavigationAgent3D
var wander_target: Vector3
var wander_timer=0

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
	if attacking:
		#_update_animation(Vector3.ZERO)
		move_and_slide()
		
	match stateRN:
		States.WANDER:
			_wanderin(delta)
			if _player_seen(detection_radius):
				stateRN=States.CHASE
		States.CHASE:
			_chasin(delta)
			if not _player_seen(detection_radius):
				stateRN=States.WANDER
			if _player_close(attack_range) and attack_timer <= 0:
				stateRN=States.ATTACK
		States.ATTACK:
			_begin_fight()
			
	move_and_slide()
	#_update_animation(velocity)
	
func _pick_new_wander_target():
	var angle = randf_range(0, TAU)
	var distance = randf_range(0, wander_radius)
	var offset = Vector3(cos(angle), 0.0 ,sin(angle)) * distance #think of the unit circle
	
	wander_target = spawn_position + offset
	agent.target_position = wander_target
	wander_timer = randf_range(1.0, 3.0)
	
func _wanderin(delta: float):
	pass

func _player_seen(limit: float):
	pass

func _player_close(limit: float):
	pass
	
func _chasin(delta:float):
	pass
	
func _begin_fight():
	pass
