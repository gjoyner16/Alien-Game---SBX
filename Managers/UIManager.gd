extends Node

var active_menu: Menu setget set_active_menu

# get the ui manager node so we can get all the children menus later
var ui

func _ready():
	# make sure we can always manipulate our menus even when we're paused
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	GameManager.connect("world_initialized", self, "_on_world_initialized")
	
func _on_world_initialized():
	initialize_ui()
			
func initialize_ui():
	ui = GameManager.ui
	
func _input(_event):
	if active_menu:
		if Input.is_action_just_pressed("exit"):
			exit_menu()
	
func set_active_menu(menu):
	# make sure all our other menus are disabled	
	for c in ui.get_children():
		c.set_active(false)
	
	# set the desired menu to active
	var menu_node = ui.get_node(menu)
	
	if menu_node:
		menu_node.set_active(true)
		active_menu = menu_node
		
		# pause the game
		GameManager.set_paused(true)
	else:
		print("Menu not found.")
		
func exit_menu():
	# can only exit a menu if we have one active
	if active_menu:
		# make sure all our other menus are disabled	
		for c in ui.get_children():
			c.set_active(false)
			
			# unpause the game
			GameManager.set_paused(false)
	# set our active menu to null
	active_menu = null
