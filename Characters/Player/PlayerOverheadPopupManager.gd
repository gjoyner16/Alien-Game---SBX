extends OverheadPopupManager

func _on_InteractionManager_area_entered(_area):
	enable_popup("interact")
	
func _on_InteractionManager_area_exited(_area):
	reset_popups()
