extends Label
const max_health := 100.0
var health := max_health
var dead := false

var dad : Node = null
const menu_path = Constants.GET_SCENE.menu
var am : float

var line_color : Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.get_damaged_bozo.connect(_on_get_damaged_bozo)
	
	dad = self.get_parent()
	am = health/40 # Replace with function body.

	
func _on_get_damaged_bozo(damageRange:Array)->void:
	if dead:
		return
	var damage := randi_range(damageRange[0],damageRange[1])
	
	health -= damage
	if health >0:
			self.text = get_health_bar()
	else:
		dead = true
		print ('you\'re dead!')
		Progress.managing=false
		SceneLoader.load_scene(menu_path)
	
func get_health_bar()-> String:
	var length = int(health/am)+1
	var line = ""
	for l in length:
		line += "|"
	line_color = Color(min(0.5,(max_health-health)/max_health)*2, min(0.5,health/max_health)*2, 0.5)
	set("theme_override_colors/font_color", line_color)
	set("theme_override_colors/font_outline_color", line_color)
	return line
	
