extends InteractionManager

var transfer_point

func _ready():
	transfer_point = get_parent()

func receive_interaction():
	# get the parent node for this interaction manager
	# so we can get our desired room and transfer point
	
	if transfer_point:
		RoomManager.transfer_player(transfer_point.to_room, transfer_point.to_point)
	else:
		print("No designated transfer point.")
