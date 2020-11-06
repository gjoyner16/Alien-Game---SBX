extends Control

class_name Menu

var active setget set_active

func _ready():
	# every menu gets initialized as not active	
	set_active(false)
	
func set_active(value):
	active = value
	
	# set the menu to visible if it's active	
	if active:
		visible = true
		
		reset_menu()
	else:
		visible = false
		
func reset_menu():
	pass

