extends Character

func _on_items_loaded():
	# equip some equipment for testing	
	ItemManager.equip(self, "SMG")
