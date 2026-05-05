extends CharacterBody3D

const SPEED = 30.0
const JUMP_VELOCITY = 15
var ap:Node = null
var hb:Node = null

enum Action {STILL, MOVE, JUMP, DAMAGED, ATTACKING}
var last_action = Action.STILL
var new_action

var damaged = false
var attacking = false

func _ready() -> void:
	set_physics_process(false)
	Progress.managing_progress()
	await SignalBus.settled_data
	
	ap = $MeshInstance3D/Sprite3D
	set_physics_process(true)
	
	

func _physics_process(delta: float) -> void:
	# Add the gravity.s
	if not is_on_floor():
		velocity += get_gravity() * delta * 2.5
	else:
		new_action=Action.STILL
	
	if (velocity.x!=0 or velocity.z!=0) and is_on_floor():
		new_action = Action.MOVE
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		new_action = Action.JUMP
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if attacking: new_action = Action.ATTACKING
	if damaged: new_action = Action.DAMAGED
	
	
	if Input.is_action_pressed("left"):
		ap.flip_h = true
	if Input.is_action_pressed("right"):
		ap.flip_h = false
	move_and_slide()
	if Input.is_action_just_pressed("attack"):
		damaged = false
		attacking = true
		new_action = Action.ATTACKING
	
	if new_action!=last_action: change_animation(new_action)
	last_action = new_action
	
	if not ap.is_playing():
		damaged = false
		attacking = false	
	
func change_animation(n_a)->void:
	match n_a:
		Action.STILL:
			ap.play("default")
		Action.JUMP:
			ap.play("jump")
		Action.MOVE:
			ap.play("walk")
		Action.DAMAGED:
			ap.play("get_hit")
			if is_on_floor(): velocity.y = JUMP_VELOCITY/2
		Action.ATTACKING:
			ap.play("attack")
