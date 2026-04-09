extends Node


#UID values : String
const menu_path := Constants.GET_SCENE.menu 
const level1_path := Constants.GET_SCENE.level1
const loading_path := Constants.GET_SCENE.loadingScreen
const logger_path := Constants.GET_SCENE.openGame

const monster_path := Constants.GET_CHARACTER.monster_thing
const player_path := Constants.GET_CHARACTER.player
const item_path := Constants.GET_CHARACTER.item

#objects : Nodes
var player : Node = null
var playerHealth : Node = null

func _ready() -> void:
	#This space is for writing tester's code.an example of a function is provided below
	
	#
	player = get_tree().get_nodes_in_group('Player')[0]
	playerHealth = player.find_child('MainHealthBar')
	print (playerHealth) # returns data about Node
	
