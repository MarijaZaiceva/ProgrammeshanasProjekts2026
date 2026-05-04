extends Panel
var ap:Node=null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ap = $"../AnimationPlayer"
	if not Progress.already_settled:
		await SignalBus.settled_data
		ap.play("when_data_is_loaded")
		await ap.animation_finished
	self.visible = false
	Progress.already_settled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
