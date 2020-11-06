extends Node

signal recipes_loaded
signal player_inventory_loaded
signal player_equipment_loaded

var recipes: Array
var player_inventory: Array
var player_equipment: Array

# temporary, for testing
var starting_inventory = [{"item": "Scrap Metal", "quantity": 2}, {"item": "Wood", "quantity": 5}]
var starting_equipment = [{"item": "Pistol"}, {"item": "SMG"}, {"item": "Overalls_TORSO"}, {"item": "Overalls_LEG_LEFT"}, {"item": "Overalls_LEG_RIGHT"}, {"item": "Overalls_FOOT_LEFT"}, {"item": "Overalls_FOOT_RIGHT"}]

func _ready():
	# warning-ignore:return_value_discarded
	ItemManager.connect("items_loaded", self, "_on_items_loaded")

func _on_items_loaded():
	# once we have our items, we can initialize everything else	
	load_recipes()
	load_player_inventory()
	load_player_equipment()
	
func load_recipes():
	var file = File.new()
	file.open("user://recipes.json", file.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json)
	file.close()

	recipes = json_result.get_result().get("recipes")
	
	emit_signal("recipes_loaded")
	
func get_recipe(item):
	for r in recipes:
		# next find the requested recipe
		if r.item == item:
			return r
	
func load_player_inventory():
	var file = File.new()
	
	if file.file_exists("user://player_inventory.json"):
		file.open("user://player_inventory.json", file.READ)
		var json = file.get_as_text()
		var json_result = JSON.parse(json)
		file.close()
		
		player_inventory = json_result.get_result().get("player_inventory")
		print("Inventory loaded.")
	else:
		for i in starting_inventory:
			# add some kind of starting equipment here if we want
			player_inventory.append({"item": i.get("item"), "quantity": i.get("quantity")})
			print(i.get("item") + " is now available in player's inventory.")
			
		save("user://player_inventory.json", "player_inventory", player_inventory)
	
	emit_signal("player_inventory_loaded")
	
func load_player_equipment():
	var file = File.new()
	
	if file.file_exists("user://player_equipment.json"):
		file.open("user://player_equipment.json", file.READ)
		var json = file.get_as_text()
		var json_result = JSON.parse(json)
		file.close()
		
		player_equipment = json_result.get_result().get("player_equipment")
		print("Equipment loaded.")
	else:
		for i in starting_equipment:
			# add some kind of starting equipment here if we want
			player_equipment.append({"item": i.get("item")})
			print(i.get("item") + " is now available in player's equipment.")
			
		save("user://player_equipment.json", "player_equipment", player_equipment)
	
	emit_signal("player_equipment_loaded")

func update_player_inventory(item, qty):
	# keep track of how many times we've seen this same item in our inventory	
	var count = 0
	
	# first check if the item already exists in our inventory
	for i in player_inventory:
		if i.item == item:
			# it does already exist, print a message and exit, no need
			# to do anything else
			count = count + 1
			
	if count == 0:
		# we did not already have this item in our inventory
		# we need to add it to the player_inventory array.
		var new_item = { "item": item, "quantity": qty }
		player_inventory.append(new_item)
		print(item + " quantity is now " + str(qty) + ".")
	else:
		for i in player_inventory:
			if i.item == item:
				# it does already exist, let's see if our updated quantity puts us below 0
				# this is only relevant for when our qty passed in is negative, but the
				# logic should work all the same.	
				if i.quantity + qty <= 0:
					# let's just remove this item from the array
					player_inventory.erase(i)
					print(i.item + " removed from inventory.")
				else:
					i.quantity = i.quantity + qty
					print(i.item + " quantity is now " + str(i.quantity) + ".")

	save("user://player_inventory.json", "player_inventory", player_inventory)
	
func update_player_equipment(item):
	# keep track of how many times we've seen this same item in our inventory	
	var count = 0
	
	# first check if the item already exists in our inventory
	for i in player_equipment:
		if i.item == item:
			# it does already exist, print a message and exit, no need
			# to do anything else
			count = count + 1

	if count == 0:
		# we did not already have this item in our equipment
		# we need to add it to the player_equipment array.
		var new_item = {"item": item}
		player_equipment.append(new_item)
		print(item + " is now available in player's equipment.")
	
		save("user://player_equipment.json", "player_equipment", player_equipment)
	else:
		print(item + " already exists in equipment.")
	
func can_craft(item):
	# create a temporary array that we can use to check if we have
	# all the required ingredients	
	# warning-ignore:unassigned_variable
	var needed_ingredients: Array
	
	# get our recipt based on the name of the item
	var r = get_recipe(item)
	# add all the needed ingredients to an array so we can make sure we
	# have enough in inventory before we craft
	for i in r.ingredients:
		needed_ingredients.append(i)
	
	if needed_ingredients:
		# now check the quantities against our player's inventory
		for pi in player_inventory:
			for i in needed_ingredients:
				if pi.item == i.item:
					# subtract our inventory qty from the needed qty,
					# we'll be checking later to see if any required qtys
					# are > 0
					if i.quantity > pi.quantity:
						return
					else:
						needed_ingredients.erase(i)
						
		# if we made it here, everything is good and we can craft the item
		if needed_ingredients.size() > 0:
			return false
		else:
			return true
	
func craft(item):
	# we have a standalone command to check if we can craft the item,
	# we should have already run that but, we'll run it again here
	# just in case			
	if can_craft(item):
		# we made it here, we had all the required ingredients
		# add the crafted item to the player's equipment
		update_player_equipment(item)
		
		# create a temporary array that we can use to check if we have
		# all the required ingredients	
		# warning-ignore:unassigned_variable
		var needed_ingredients: Array
		
		# get our recipt based on the name of the item
		var r = get_recipe(item)
		
		# add all the needed ingredients to an array so we can make sure we
		# have enough in inventory before we craft
		for i in r.ingredients:
			needed_ingredients.append(i)
			
		# decrement the player's inventory for all the ingredients that were
		# used to craft the item
		for i in needed_ingredients:
			update_player_inventory(i.item, -i.quantity)
	
func save(file_name, key, value):
	var file = File.new()
	# open up the file so we can write to it	
	file.open(file_name, File.WRITE)
	# create a dictionary using the appropriate header for the file	
	var new_file = { key: value }
	# store this as the first line in the file (which will always
	# override anything that was already there)	
	file.store_string(to_json(new_file))
	file.close()
	print("Save successful.")
	
func get_owned_quantity(item):
	for i in player_inventory:
		# next find the requested item
		if i.item == item:
			return i.quantity
