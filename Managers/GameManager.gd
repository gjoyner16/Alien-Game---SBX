extends Node

signal world_initialized

var paused setget set_paused, get_paused

var world
var player
var rooms
var eras
var ui
var items: Array

# starting room
var start_room = "MainArea"

func _process(_delta):
	if not world:
		initialize_world()

func initialize_world():
	# just go ahead and randomize everything
	randomize()
		
	# get all our key nodes so we can always access them through the
	# GameManager singleton	
	world = get_tree().get_root().get_node("/root/World")
	player = get_tree().get_root().get_node("/root/World/Player")
	rooms = get_tree().get_root().get_node("/root/World/Rooms")
	eras = get_tree().get_root().get_node("/root/World/Rooms/Eras")
	ui = get_tree().get_root().get_node("/root/World/UI")
	
	if world:
		emit_signal("world_initialized")
		
		# we're just plugging in a string here, elsewhere we're passing
		# in the actual node, so we need to get the node				
		var room_node = rooms.get_node(start_room)
		var transfer_point_node = rooms.get_node(start_room)
		
		# transfer the player to the game's designated starting room and point
		RoomManager.transfer_player(room_node, transfer_point_node)
		
func set_paused(boolean):
	get_tree().paused = boolean
	
func get_paused():
	return paused

