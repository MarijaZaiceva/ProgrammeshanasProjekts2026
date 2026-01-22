extends Sprite3D

@export var speed = 14

var target_velocity = Vector3.ZERO

func _physics_process(event):
	var direction = Vector3.ZERO
	if event.is_action_pressed("right"):
		direction.x += 1
	if event.is_action_pressed("left"):
		direction.x -= 1
	if event.is_action_pressed("back"):
		direction.z += 1
	if event.is_action_pressed("forward"):
		direction.z -= 1
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
