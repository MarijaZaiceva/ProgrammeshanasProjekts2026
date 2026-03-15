extends Node

var panel: Node = null
var textInside: Node = null
var loaded: bool = false
var is_talking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func start_talking_with_(name: String) -> void:
	if not loaded:
		load_needed_things_pls()
		loaded = true
	if is_talking:
		return
	is_talking = true
	panel.set_visible(true)
	say(name)
	
func load_needed_things_pls() -> void:
	panel = get_tree().get_nodes_in_group("SpeechPanel")[0]
	textInside = get_tree().get_nodes_in_group("SpeechPanel")[1]
	
func say(words: String):
	for letter in words:
		await get_tree().create_timer(0.1).timeout
		textInside.text = textInside.text+letter
	await get_tree().create_timer(3.0).timeout
	textInside.text = ""
	panel.set_visible(false)
	is_talking = false
	
