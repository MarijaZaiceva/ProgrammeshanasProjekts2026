extends Panel

var username = ""
var password

const ButtonText = ["Log in", "Sign in"]
const ButtonGroups = ["LoginObjects","SigninObjects"]
enum Operations {LOG_IN, SIGN_IN}
var operationRN = Operations.LOG_IN

var switch_button: Node = null
var input_button: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	switch_button = get_tree().get_nodes_in_group("Buttons")[0]
	input_button = get_tree().get_nodes_in_group("Buttons")[1]

func _change_operation() -> void:
	match operationRN:
		Operations.LOG_IN:
			operationRN = Operations.SIGN_IN
		Operations.SIGN_IN:
			operationRN = Operations.LOG_IN
	input_button.text=(ButtonText[operationRN])
	switch_button.text=(ButtonText[1-operationRN])
	
	for obj in get_tree().get_nodes_in_group(ButtonGroups[operationRN]):
		obj.set_visible(true)
	for obj in get_tree().get_nodes_in_group(ButtonGroups[1-operationRN]):
		obj.set_visible(false)

func _on_switch_op_button_down() -> void:
	_change_operation()
	 # Replace with function body.
