extends InteractionManager

var transfer_point

func _ready():
	transfer_point = get_parent()

func receive_interaction():
	# call to the run manager to generate the next room
	RunManager.next_room(transfer_point.direction)
