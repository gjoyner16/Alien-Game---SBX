extends Menu

var selected_tab = 0
var selected_item = 0

export var good_color: Color
export var bad_color: Color

onready var equipment = $Equipment
onready var weapons = $Equipment/Weapons
onready var gear = $Equipment/Gear
onready var equipped_slot = $Equipped/EquippedLists/Slot
onready var equipped_item = $Equipped/EquippedLists/Item
onready var equip_button = $EquipButton
onready var stats = $Equipped/Stats

func _ready():
	# all menus should start as inactive	
	set_active(false)
	
	# warning-ignore:return_value_discarded
	CraftingManager.connect("player_equipment_loaded", self, "_on_player_equipment_loaded")
	
func _on_player_equipment_loaded():
	# Load the equipment by stepping through it and adding each item.
	set_equipment()
			
	# item slots don't change, so let's initialize them here	
	for s in ItemManager.GearPosition:
		equipped_slot.add_item(s,null,false)

	# automatically select the first item in the weapons menu	
	weapons.select(0,true)
	
	# reset the menu
	reset_menu()	
	
func reset_menu():
	# refresh the equipment list and what is equipped
	set_equipment()
	# reset the stats for the current equipment	
	set_stats()
	
	# every time we open up the menu we want to
	# start on the first tab	
	equipment.set_current_tab(selected_tab)
	set_selection(selected_tab)
	
	# reset each lists contents
	equipped_item.clear()

	# get our list of what we have equipped and update the list
	# with those items names
	if GameManager.player:
		for i in ItemManager.GearPosition:
			var eq = GameManager.player.equipment.get(i)
			
			if eq:
				equipped_item.add_item(eq.name,null,false)

func _on_Equipment_tab_changed(tab):
	selected_tab = tab
	set_selection(tab)

func _on_Weapons_item_selected(index):
	if weapons.is_item_selectable(index):
		selected_item = weapons.get_item_text(index)

func _on_Gear_item_selected(index):
	if gear.is_item_selectable(index):
		selected_item = gear.get_item_text(index)
	
func set_equipment():
	# clear both equipment lists	
	weapons.clear()
	gear.clear()
	
	for e in CraftingManager.player_equipment:
		# get the item information for this recipe
		var i = ItemManager.get_item(e.item)
		
		# items that are already equipped
		# get the slot that the item would go in and check
		# if this item is already equipped
		var eq = GameManager.player.equipment.get(i.position)
		if eq.name == i.name:
			if i.type == "WEAPON":
				weapons.add_item(e.item,null,false)
			else:
				gear.add_item(e.item,null,false)
		# item is not equipped
		else:
			if i.type == "WEAPON":
				weapons.add_item(e.item,null,true)
			else:
				gear.add_item(e.item,null,true)
				
func set_selection(tab):
	# whenever a tab is changed, automatically select the first
	# item in the list on that tab
	if tab == 0:
		if weapons:
			# automatically select the first selectable item
			var i = 0
			while i < weapons.get_item_count():
				if weapons.is_item_selectable(i):
					weapons.select(i,true)
					selected_item = weapons.get_item_text(i)
					set_equip_button()
					return
					
				i = i + 1
				
			# otherwise selected item should be null
			selected_item = null	
	else:
		if gear:
			# automatically select the first selectable item
			var i = 0
			while i < gear.get_item_count():
				if gear.is_item_selectable(i):
					gear.select(i,true)
					selected_item = gear.get_item_text(i)
					set_equip_button()
					return
					
				i = i + 1
				
			# otherwise selected item should be null
			selected_item = null
	
	set_equip_button()

func set_stats():
	stats.set_text("HP: " + str(GameManager.player.stats.max_hp) + ", Armor: " + str(GameManager.player.stats.armor))
		
func set_equip_button():
	if selected_item == null:
		equip_button.disabled = true
	else:
		equip_button.disabled = false
		
func _on_EquipButton_pressed():
	# equip the item	
	ItemManager.equip(GameManager.player, selected_item)
	
	# update the equipped menu	
	reset_menu()
