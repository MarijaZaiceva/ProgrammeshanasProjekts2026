extends CharacterBody3D

var spawn_position: Vector3
var direction: Vector3 = Vector3.ZERO
enum States { WANDER, CHASE, ATTACK }
var stateRN: States = States.WANDER
var goal: Node = null
var attack_timer: float = 0.0
var attacking: bool = false
const detection_radius = 300.0
const attack_range = 10
const wander_radius = 40
const wander_speed = 5
const chase_speed = 25
@onready var agent: NavigationAgent3D = $NavigationAgent3D
var wander_target: Vector3
var wander_timer=0


func _ready():
	spawn_position = global_position
	#state_machine = anim_tree.get("parameters/playback")
	goal = get_tree().get_nodes_in_group("Player")[0]
		
	print(goal)
	pick_new_wander_target()
	
func _process(delta: float) -> void:
	if not goal:
		return
	if attack_timer > 0:
		attack_timer-=delta
	if attacking:
		#_update_animation(Vector3.ZERO)
		move_and_slide()                   
		
	match stateRN:
		States.WANDER:   
			wanderin(delta)
			
			if player_seen(detection_radius):
				stateRN=States.CHASE
		States.CHASE:
			print("im chasin :3")
			chasin(delta)
			if not player_seen(detection_radius):
				stateRN=States.WANDER
			if player_close() and attack_timer <= 0:
				stateRN=States.ATTACK
		States.ATTACK:
			_begin_fight()
			
	move_and_slide()
	#_update_animation(velocity)
	
func pick_new_wander_target():
	var angle = randf_range(0, TAU)
	var distance = randf_range(0, wander_radius)
	var offset = Vector3(cos(angle), 0.0 ,sin(angle)) * distance #think of the unit circle
	
	wander_target = spawn_position + offset
	agent.target_position = wander_target
	wander_timer = randf_range(1.0, 3.0)
	
func set_next_path(speed):
	var next_pos = agent.get_next_path_position()
	direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	agent.set_velocity(velocity)
	
func wanderin(delta: float):
	wander_timer -= delta
	if global_position.distance_to(wander_target) < 8.0 or agent.is_navigation_finished():
		velocity = Vector3.ZERO
		if wander_timer <= 0:
			pick_new_wander_target()
		return
	set_next_path(wander_speed)
	
func player_seen(visible_dist: float):
	return is_instance_valid(goal) and global_position.distance_to(goal.global_position) <= visible_dist

func player_close():
	return is_instance_valid(goal) and global_position.distance_to(goal.global_position) <= attack_range
	
func chasin(delta:float) -> void :
	if not goal:
		return
	agent.target_position = goal.global_position
	set_next_path(chase_speed)
	
func _begin_fight():
	pass
