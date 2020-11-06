extends Area2D

class_name InteractionManager

var enabled = true setget set_enabled
var current_interaction: InteractionManager

func set_enabled(boolean):
	enabled = boolean
	
	# make sure we can't interact with these if they've been disabled	
	if enabled:
		monitorable = true
		monitoring = true
	else:
		monitorable = false
		monitoring = false

func initiate_interaction():
	if current_interaction != null:
		current_interaction.receive_interaction()
		
func receive_interaction():
	print("No interaction reception behavior defined.")
	
func _on_InteractionManager_area_entered(area):
	current_interaction = area

func _on_InteractionManager_area_exited(area):
	if current_interaction == area:
		current_interaction = null
