extends Label3D

const hitbox_radius:= 15
var dad: Node = null
var player: Node = null
var health :float = 12
var max_health :float
var dealt_damage :float = 5
var am :float = 0
var drop_it: PackedScene = preload(Constants.GET_CHARACTER.item)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	dad = self.get_parent()
	max_health=health
	am = health/6
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	if player_around() and Input.is_action_just_pressed("attack"):
		health-=dealt_damage

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
	var rand = randf_range(1,2)
	for x in rand:
		var new_item = drop_it.instantiate()
		new_item.global_position = dad.global_position	
		get_tree().get_first_node_in_group("Level").add_child.call_deferred(new_item)
	dad.queue_free()
		
