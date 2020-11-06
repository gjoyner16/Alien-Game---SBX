extends Node

signal items_loaded

enum ItemType { WEAPON, GEAR, INGREDIENT }
enum WeaponType { MAIN, OFFHAND }
enum GearPosition { weaponLeft, weaponRight, gearTorso, gearLegLeft, gearLegRight, gearFootLeft, gearFootRight }

var items

var weapon_none = preload("res://Items/Weapons/None.tscn")
var gear_none = preload("res://Items/Gear/None.tscn")

func _ready():
	# warning-ignore:return_value_discarded
	GameManager.connect("world_initialized", self, "_on_world_initialized")

	# warning-ignore:return_value_discarded
	CraftingManager.connect("player_equipment_loaded", self, "_on_player_equipment_loaded")

func _on_world_initialized():
	load_items()
	
func load_items():
	var file = File.new()
	file.open("user://items.json", file.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json)
	file.close()

	items = json_result.get_result().get("items")
	
	if items:
		# need to wait a second so any scripts that use this can get connected
		yield(get_tree().create_timer(1), "timeout")
	
		emit_signal("items_loaded")
		
func get_item(item):
	for i in items:
		if i.name == item:
			return i
			
	print("Item " + item + "not found.")
		
func equip(character, item):
	# get our item information	
	var i = get_item(item)
	
	if i:
		# get the position from the item information
		var position = i.position
			
		# still couldn't get a position, exit
		if not position:
			print("Could not get a position for this item.")
			return
			
		# check and make sure the item isn't already equipped
		var eq = character.equipment.get(position)
		if eq:
			if eq.name == item:
				print(item + " already equipped.")
				return	
	
		var new_item = load(i.scene)
		var item_instance = new_item.instance()
		
		if position == "weaponLeft":
			if character.weaponLeft:
				unequip(character, position)
				
			character.equipmentArmLeft.add_child(item_instance)
			character.weaponLeft = item_instance
			
		if position == "weaponRight":
			if character.weaponRight:
				unequip(character, position)
				
			character.equipmentArmRight.add_child(item_instance)
			character.weaponRight = item_instance
			
		if position == "gearTorso":
			if character.gearTorso:
				unequip(character, position)
				
			character.equipmentTorso.add_child(item_instance)
			character.gearTorso = item_instance
			
		if position == "gearLegLeft":
			if character.gearLegLeft:
				unequip(character, position)
				
			character.equipmentLegLeft.add_child(item_instance)
			character.gearLegLeft = item_instance
			
		if position == "gearLegRight":
			if character.gearLegRight:
				unequip(character, position)
				
			character.equipmentLegRight.add_child(item_instance)
			character.gearLegRight = item_instance
			
		if position == "gearFootLeft":
			if character.gearFootLeft:
				unequip(character, position)
				
			character.equipmentFootLeft.add_child(item_instance)
			character.gearFootLeft = item_instance
			
		if position == "gearFootRight":
			if character.gearFootRight:
				unequip(character, position)
				
			character.equipmentFootRight.add_child(item_instance)
			character.gearFootRight = item_instance
			
		item_instance.set_character(character)
		
		# update the characters equipment array
		character.update_equipment()
		
		if i.get("gear"):
			# max hp modifer
			character.stats.apply_modifier(item, "max_hp", "+", i.gear.max_hp)
			# armor modifer
			character.stats.apply_modifier(item, "armor", "+", i.gear.armor)
		
func unequip(character, position):	
	# gotta be a better way to do this but it will work for now,
	# clear the item instance that's a child of the appropriate
	# gear node, then set the variable to null
	var current_item
	
	if position == "weaponLeft":
		character.equipmentArmLeft.get_child(0).queue_free()
		if character.weaponLeft:
			current_item = character.weaponLeft
			
		character.weaponLeft = null
		
	if position == "weaponRight":
		character.equipmentArmRight.get_child(0).queue_free()
		if character.weaponRight:
			current_item = character.weaponRight
		
		character.weaponRight = null
		
	if position == "gearTorso":
		character.equipmentTorso.get_child(0).queue_free()
		if character.gearTorso:
			current_item = character.gearTorso
		
		character.gearTorso = null
		
	if position == "gearLegLeft":
		character.equipmentLegLeft.get_child(0).queue_free()
		if character.gearLegLeft:
			current_item = character.gearLegLeft
		
		character.gearLegLeft = null
		
	if position == "gearLegRight":
		character.equipmentLegRight.get_child(0).queue_free()
		if character.gearLegRight:
			current_item = character.gearLegRight
		
		character.gearLegRight= null
		
	if position == "gearFootLeft":
		character.equipmentFootLeft.get_child(0).queue_free()
		if character.gearFootLeft:
			current_item = character.gearFootLeft
		
		character.gearFootLeft = null
		
	if position == "gearFootRight":
		character.equipmentFootRight.get_child(0).queue_free()
		if character.gearFootRight:
			current_item = character.gearFootRight
			
		character.gearFootRight = null
		
	# update the characters equipment array
	character.update_equipment()
	
	# remove all modifiers coming from the item
	character.stats.remove_modifier(current_item.name)	

func _on_player_equipment_loaded():
	# for the time being let's just equip the first piece of gear
	# for each slot in our inventory
	for e in CraftingManager.player_equipment:
		equip(GameManager.player, e.item)
