extends Control
var inv: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inv = self.find_child("Inventory")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	inv.text=items()
	inv.visible = true
	
func _on_button_up() -> void:
	inv.visible = false
	print(inv.visible)
		
func items()->String:
	return "Money: " + str(int(Progress.PROGRESS["money"]))+"
Weapon: " + str(Progress.PROGRESS["weapon"])
