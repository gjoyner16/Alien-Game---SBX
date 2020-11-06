extends StaticBody2D

class_name Room

var enabled = true setget set_enabled
var transfer_points: Array

onready var items = $Objects/Items
onready var characters = $Objects/Characters
onready var collision = $CollisionPolygon2D

func _ready():
	for t in get_node("TransferPoints").get_children():
		transfer_points.append(t)
		
func reset_room():
	for c in characters.get_children():
		# make sure it's not the player
		if c != GameManager.player:
			c.queue_free()
			
	for i in items.get_children():
		i.queue_free()
		
func set_enabled(boolean):
	enabled = boolean
	
	if enabled:
		# room itself should be visible
		# transfer points should be enabled and the collision
		# should be enabled
		visible = true
		
		for t in transfer_points:
			t.get_node("InteractionManager").set_enabled(true)
			
		collision.disabled = false
	else:
		# room itself should not be visible
		# no transfer points should be enabled and the collision
		# should be disabled
		visible = false
		
		for t in transfer_points:
			t.get_node("InteractionManager").set_enabled(false)
			
		collision.disabled = true
			
		
