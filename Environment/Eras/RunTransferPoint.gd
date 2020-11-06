extends TransferPoint

enum Direction { START, UP, DOWN, LEFT, RIGHT }

export(Direction) var direction

var transfer_point

onready var interaction_manager = $InteractionManager

func _ready():
	transfer_point = get_parent()
