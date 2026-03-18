extends CharacterBody3D

var spawn_position: Vector3
var direction: Vector3 = Vector3.ZERO
enum States { WANDER, CHASE, PAUSE, ATTACK}
var stateRN: States = States.WANDER
var goal: Node = null
var attack_timer: float = 0.0
var attacking: bool = false
const detection_radius = 20.0
const attack_range = 0
const wander_radius = 40
const wander_speed = 5
const chase_speed = 25
@onready var agent: NavigationAgent3D = $NavigationAgent3D
var wander_target: Vector3
var wander_timer=0
var healthbar : Node = null


func _ready():
	spawn_position = global_position
	healthbar = self.find_child('HealthBar')
	#state_machine = anim_tree.get("parameters/playback")
	goal = get_tree().get_nodes_in_group("Player")[0]
		
	pick_new_wander_target()
	
func _process(delta: float) -> void:
	if not goal:
		return
	if attacking:
		#_update_animation(Vector3.ZERO)
		move_and_slide()                   
		
	match stateRN:
		States.WANDER:   
			wanderin(delta)
			if player_in_(detection_radius):
				healthbar.visible = true
				stateRN=States.CHASE
		States.CHASE:
			chasin(delta)
			if not player_in_(detection_radius):
				healthbar.visible = false
				stateRN=States.WANDER
			if player_in_(attack_range) and attack_timer <= 0:
				stateRN=States.ATTACK
		States.ATTACK:
			attacking = true
			dash_through()
			
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
	if global_position.distance_to(wander_target) < wander_speed-1.0 or agent.is_navigation_finished():
		velocity = Vector3.ZERO
		if wander_timer <= 0:
			pick_new_wander_target()
		return
	set_next_path(wander_speed)
	
func player_in_(visible_dist: float):
	return is_instance_valid(goal) and global_position.distance_to(goal.global_position) <= visible_dist
	
func chasin(delta:float) -> void :
	if not goal:
		return
	agent.target_position = goal.global_position
	set_next_path(chase_speed)
	
func dash_through():
	agent.target_position = global_position
	set_process(false)
	await get_tree().create_timer(1).timeout
	agent.target_position = Vector3(0,0,-100)
