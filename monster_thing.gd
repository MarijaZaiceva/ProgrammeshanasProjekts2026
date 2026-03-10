extends CharacterBody3D

# 1. Define the States using an Enum
enum EnemyState { IDLE, PURSUING }

# 2. Variables
var current_state = EnemyState.IDLE
var player: Node3D  # Reference to the player node
var speed = 5.0
var detection_range = 15.0
var detection_timer = 0.0
var detection_cooldown = 0.5  # Prevents flickering states

func _ready() -> void:
	# Find the player node. 
	# Ideally, assign this in the Inspector, but this works for auto-finding.
	player = get_node_or_null("res://Characters/player.tscn")
	if not player:
		push_warning("Enemy: Player node not found!")

func _physics_process(_delta: float) -> void:
	# Safety check: If no player exists, stop logic
	if not player:
		return

	# 3. Calculate Distance to Player
	var distance_to_player = global_position.distance_to(player.global_position)

	# 4. State Logic (The "Brain")
	if distance_to_player <= detection_range:
		# If player is close, switch to Pursuing
		current_state = EnemyState.PURSUING
	else:
		# If player is far, switch to Idle
		current_state = EnemyState.IDLE

	# 5. Handle Movement based on State
	match current_state:
		EnemyState.IDLE:
			# Stop moving
			velocity = Vector3.ZERO
			# Optional: Rotate to face player while idle
			# look_at(player.global_position)
			
		EnemyState.PURSUING:
			# Calculate direction towards player
			var direction = (player.global_position - global_position).normalized()
			
			# Apply speed to velocity
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed

	# 6. Apply Physics
	move_and_slide()
