extends StaticBody3D
class_name collectable

var player:Node = null
var x : float
var y : float
var z : float
var dropping : bool = false
var invincible : bool = true
var angle : int
var rad := 0.0
const max_rad := 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	player = get_tree().get_first_node_in_group("Player")
	x = self.global_position.x
	y = self.global_position.y
	z = self.global_position.z

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not dropping:
		angle = int(randf_range(0, TAU))
		dropping = true
	rad+= 3*delta
	self.global_position = Vector3(x+rad*cos(angle),
	max(y,y+max_rad*sqrt((rad*cos(angle))**2+(rad*sin(angle))**2)-((rad*cos(angle))**2+(rad*sin(angle))**2)),
	z+rad*sin(angle)) 
	if rad >= max_rad:
		set_process(false)
		invincible = not invincible


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("seeing you")
	if invincible:
		return
	if body == player:
		queue_free()
