extends CanvasLayer

signal loading_screen_ready

@export var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await animation_player.animation_finished
	loading_screen_ready.emit()

func _on_progress_changed(new_value: float) -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_load_finished() -> void:
	animation_player.play_backwards("Transition")
	await animation_player.animation_finished
	queue_free()
