extends CharacterBody3D

const SPEED = 30.0
const JUMP_VELOCITY = 15

func _ready() -> void:
	set_physics_process(false)
	Progress.managing_progress()
	await SignalBus.settled_data
	set_physics_process(true)
	
	

func _physics_process(delta: float) -> void:
	# Add the gravity.s
	if not is_on_floor():
		velocity += get_gravity() * delta * 2.5

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
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
		
	move_and_slide()
		
	
