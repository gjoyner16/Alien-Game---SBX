extends Menu

var selected_item = 0

export var good_color: Color
export var bad_color: Color

onready var recipes = $Recipes
onready var weapons = $Recipes/Weapons
onready var gear = $Recipes/Gear
onready var ingredient_items = $Ingredients/IngredientsLists/Item
onready var ingredient_needed = $Ingredients/IngredientsLists/Needed
onready var ingredient_owned = $Ingredients/IngredientsLists/Owned
onready var craft_button = $CraftButton

func _ready():
	# all menus should start as inactive	
	set_active(false)
	
	# warning-ignore:return_value_discarded
	CraftingManager.connect("recipes_loaded", self, "_on_recipes_loaded")
	
func _on_recipes_loaded():
	# Load the recipe lists by stepping through it and adding each item.
	for r in CraftingManager.recipes:
		# get the item information for this recipe
		var i = ItemManager.get_item(r.item)
		
		if i.type == "WEAPON":
			weapons.add_item(r.item,null,true)
		else:
			gear.add_item(r.item,null,true)

	# automatically select the first item in the weapons menu	
	weapons.select(0,true)
	# load the ingredients for that item	
	selected_item = weapons.get_item_text(0)
	set_ingredients(selected_item)
	
func reset_menu():
	# every time we open up the menu we want to
	# start on the first tab	
	recipes.set_current_tab(0)
	selected_item = weapons.get_item_text(0)
	set_ingredients(selected_item)

func _on_Recipes_tab_changed(tab):
	# whenever a tab is changed, automatically select the first
	# item in the list on that tab
	if tab == 0:
		if weapons:
			# automatically select the first item in the weapons menu	
			weapons.select(0,true)
			# load the ingredients for that item	
			selected_item = weapons.get_item_text(0)
			set_ingredients(selected_item)
	else:
		if gear:
			# automatically select the first item in the gear menu	
			gear.select(0,true)
			# load the ingredients for that item	
			selected_item = gear.get_item_text(0)
			set_ingredients(selected_item)

func _on_Weapons_item_selected(index):
	# when the selection is changed, update the ingredients
	# list
	selected_item = weapons.get_item_text(index)
	set_ingredients(selected_item)

func _on_Gear_item_selected(index):
	# when the selection is changed, update the ingredients
	# list
	selected_item = gear.get_item_text(index)
	set_ingredients(gear.get_item_text(index))

func set_ingredients(item):
	# go ahead and update the craft button here	
	set_craft_button()
	
	# reset each lists contents
	ingredient_items.clear()
	ingredient_needed.clear()
	ingredient_owned.clear()
	
	var current_ingredient = 0
	
	for i in CraftingManager.get_recipe(item).ingredients:
		# get the quantity owned
		var owned = CraftingManager.get_owned_quantity(i.item)
		# if we dont have any of this ingredient, display 0	
		if !owned:
			owned = 0
		
		# items
		if ingredient_items:
			ingredient_items.add_item(i.item,null,false)
			# set the color of the item in the list based on if we have enough or not
			if owned >= i.quantity:
				ingredient_items.set_item_custom_fg_color(current_ingredient, good_color)
			else:
				ingredient_items.set_item_custom_fg_color(current_ingredient, bad_color)
			
		if ingredient_needed:
			ingredient_needed.add_item(str(i.quantity),null,false)
			# set the color of the item in the list based on if we have enough or not
			if owned >= i.quantity:
				ingredient_needed.set_item_custom_fg_color(current_ingredient, good_color)
			else:
				ingredient_needed.set_item_custom_fg_color(current_ingredient, bad_color)
			
		if ingredient_owned:
			ingredient_owned.add_item(str(owned),null,false)
			# set the color of the item in the list based on if we have enough or not
			if owned >= i.quantity:
				ingredient_owned.set_item_custom_fg_color(current_ingredient, good_color)
			else:
				ingredient_owned.set_item_custom_fg_color(current_ingredient, bad_color)
				
		current_ingredient = current_ingredient + 1
		
func set_craft_button():
	# update the craft button based on whether or not
	# we have the ingredients to craft the item
	if CraftingManager.can_craft(selected_item):
		craft_button.disabled = false
	else:
		craft_button.disabled = true
		
func _on_CraftButton_pressed():
	# craft the item, then update our ingredients list	
	CraftingManager.craft(selected_item)
	set_craft_button()
	set_ingredients(selected_item)
