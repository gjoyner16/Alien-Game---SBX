extends Node

var active_room: Room
var rooms: Array

func _ready():
	# game manager needs to be loaded first	
	# warning-ignore:return_value_discarded
	GameManager.connect("world_initialized", self, "_on_world_initialized")
	
func _on_world_initialized():
	# load in all of our possible rooms and rooms within eras
	for r in GameManager.rooms.get_children():
		rooms.append(r)
		
	for r in GameManager.eras.get_children():
		rooms.append(r)

func transfer_player(room, transfer_point):
	if room and transfer_point:
		# change the active camera to the camera for the new room	
		room.get_node("Camera").make_current()
		var characters = room.get_node("Objects/Characters")
		GameManager.player.get_parent().remove_child(GameManager.player)  
		characters.add_child(GameManager.player)
		GameManager.player.set_global_position(transfer_point.get_global_position())
		
		active_room = room
		print("Player transferred to " + room.name)
	else:
		print("Room not found.")
