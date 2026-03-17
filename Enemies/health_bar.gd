extends Label3D

const hitbox_radius:= 15
var dad: Node = null
var player: Node = null
var health :float = 120
var max_health :float
var dealt_damage :float = 5
var am :float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	dad = self.get_parent()
	max_health=health
	am = health/6
	print (dad)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	if player_around() and Input.is_action_just_pressed("attack"):
		health-=dealt_damage
		print(health)
		if health >0:
			self.text = get_health_bar()
		else:
			die()
func player_around() -> bool:
	return is_instance_valid(player) and global_position.distance_to(player.global_position) <= hitbox_radius
	
func get_health_bar()-> String:
	var length = int(health/am)+1
	var line = ""
	for l in length:
		line += "■"
	self.modulate = Color(min(0.5,(max_health-health)/max_health)*2, min(0.5,health/max_health)*2, 0.5)
	return line
	
func die():
	dad.queue_free()
		
