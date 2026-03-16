extends Node

@export var PROGRESS: Dictionary = {
	"last dialogue" : 4,
	"side quests" : 101,
	"locationX": 345.789,
	"locationY":34567.345,
	"sword" : 0
	}
const main_dialogue_array: Array = ["A1","B1","A2","F6"]
const additional_dialogue_array: Array = ["P1","P5"]


func _process(delta: float) -> void:
	set_process(false)
	save_progress("YOOO")
	await get_tree().create_timer(120.0).timeout
	set_process(true)
	

func get_progress (nickname: String):
	pass
	
func save_progress (nickname: String):
	print("let's consider it saved Mr. "+nickname)
	
	
