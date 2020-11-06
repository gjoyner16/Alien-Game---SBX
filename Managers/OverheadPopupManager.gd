extends Node2D

class_name OverheadPopupManager
# buttons
onready var buttonR1 = $ButtonR1

var popups: Dictionary

func _ready():
	popups = {
		"interact": buttonR1
	}

func enable_popup(event):
	# make sure all other popups are not visible
	reset_popups()
		
	# get our sprite from the dictionary using the even as
	# the key	
	var popup = popups.get(event)
	
	if popup:
		popup.visible = true
		
func reset_popups():
	for p in get_children():
		p.visible = false
