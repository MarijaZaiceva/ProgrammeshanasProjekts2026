extends CharacterBody3D

var spawn_position: Vector3
var direction: Vector3 = Vector3.ZERO
enum States { WANDER, CHASE, ATTACK}
var stateRN: States = States.WANDER
var goal: Node = null
var attack_timer : float
var attacking : bool = false
const detection_radius := 50.0
const attack_radius := 15
const wander_radius := 40
const wander_speed := 5
const attack_speed := 30 
const chase_speed := 25
@onready var agent : NavigationAgent3D = $NavigationAgent3D
var wander_target : Vector3
var wander_timer : float
var healthbar : Node = null
var planning_to:Vector3


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
		dash_through(delta)
		move_and_slide()                   
		
	match stateRN:
		States.WANDER:   
			wanderin(delta)
			if player_in_(detection_radius):
				healthbar.visible = true
				stateRN=States.CHASE
		States.CHASE:
			chasin()
			if not player_in_(detection_radius):
				healthbar.visible = false
				stateRN=States.WANDER
			if player_in_(attack_radius) and attack_timer <= 0:
				attack_timer = 1.5+delta
				direction = Vector3.ZERO
				stateRN=States.ATTACK
		States.ATTACK:
			attack_timer-=delta
			dash_through(delta)
			if attack_timer<0:
				stateRN=States.CHASE
			
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
	
func chasin() -> void :
	if not goal:
		return
	agent.target_position = goal.global_position
	set_next_path(chase_speed)
	
func dash_through(delta: float):
	match true:
		_ when attack_timer < 0.7:
			velocity = direction * delta 
			set_next_path(velocity*4)
		_ when attack_timer < 1.1:
			if attack_timer+delta>=1.1:
				planning_to=planning_to-global_position
				planning_to*=100
			agent.target_position = planning_to 
			set_next_path(attack_speed*attack_timer*2)
		_:
			
			planning_to=goal.global_position
			agent.target_position = planning_to 
			set_next_path(15)
		
	
