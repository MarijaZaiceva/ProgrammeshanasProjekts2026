extends Marker3D

var spawn_mob: PackedScene = preload(Constants.GET_CHARACTER.monster_thing)
const spawn_rad := 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.johny_is_dead.connect(johny_pls_respawn)
	for i in 5:
		spawn_()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawn_() -> void:
	var angle = randf_range(0, TAU)

	var new_mob = spawn_mob.instantiate()	
	new_mob.position = global_position + Vector3(cos(angle), 0.0 ,sin(angle)) * spawn_rad
	get_parent().add_child.call_deferred(new_mob)

func johny_pls_respawn(time: float) ->void:
	await get_tree().create_timer(time).timeout
	spawn_()
