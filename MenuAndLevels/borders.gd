extends Node
var borderTop: float = 0
var borderBottom: float = 0
var borderLeft: float = 0
var borderRight: float = 0

var tpTop: float = 0
var tpBottom: float = 0
var tpLeft: float = 0
var tpRight: float = 0

var player: Node = null
var brd: Array=[]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	brd = get_tree().get_nodes_in_group("Borders")
	player = get_tree().get_nodes_in_group("Player")[0]
	
	var mark_min= brd[0]
	var mark_max = brd[2]
	var tp_min = brd[1]
	var tp_max = brd[3]
	
	borderTop = mark_max.global_position.z
	borderBottom = mark_min.global_position.z
	borderRight = mark_max.global_position.x
	borderLeft = mark_min.global_position.x

	tpTop = tp_max.global_position.z
	tpBottom =tp_min.global_position.z
	tpRight = tp_max.global_position.x
	tpLeft =tp_min.global_position.x
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	is_inside(player.global_position.z, player.global_position.x)
	
	
func is_inside(z, x):
	if z < borderBottom:
		print (player.global_position)
		player.global_position.z = tpTop
		print (player.global_position)
	if z > borderTop:
		print (player.global_position)
		player.global_position.z = tpBottom
		print (player.global_position)
	if x < borderRight:
		print (player.global_position)
		player.global_position.x = tpLeft
		print (player.global_position)
	if x > borderLeft:
		print (player.global_position)
		player.global_position.x = tpRight
		print (player.global_position)
