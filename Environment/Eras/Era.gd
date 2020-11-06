extends Node2D

class_name Era

var rooms: Array

var current_room
var possible_next_rooms: Array

var items: Array
var enemies: Array

func _ready():
	# load in all of our possible rooms
	for r in get_children():
		rooms.append(r)
		
func start_run():
	# lets make sure we actually have a room in our era
	if rooms.size() == 0:
		print("No rooms belong to this era.")
		return
		
	# reset our array of possible next rooms
	possible_next_rooms.clear()
	
	# add all our rooms again		
	for r in rooms:
		possible_next_rooms.append(r)
	
	# for now we'll just assume the starting room is the first child of this era	
	current_room = rooms[0]
	
	var starting_transfer_point = current_room.get_node("TransferPoints/Start")

	if starting_transfer_point:
		# transfer the player to the starting point within this room
		RoomManager.transfer_player(current_room, starting_transfer_point)
		
		# make the room visible
		initialize_current_room()
		
		# remove the starting room from the possible next room
		possible_next_rooms.erase(current_room)
	else:
		print("No starting transfer point found.")
		
func next_room(direction):
	# using the direction of the room we're exiting, we need to find
	# a new room with the opposite entrance
	
	# this temporary array will store our valid rooms so that we can pick
	# a random one from there		
	# warning-ignore:unassigned_variable
	var valid_next_rooms: Array
	valid_next_rooms.clear()
	var valid_next_direction: int
	
	# START	
	if direction == 0:
		print("Run exited.")
		# eventually, this should prompt the user if they want to quit the run
		# for now, just transfer the player back to the main area
		var room_node = GameManager.rooms.get_node(GameManager.start_room)
		var transfer_point = GameManager.rooms.get_node(GameManager.start_room)
		RoomManager.transfer_player(room_node, transfer_point)
		
	# UP	
	if direction == 1:
		for r in possible_next_rooms:
			for t in r.transfer_points:
				if t.direction == 2:
					valid_next_rooms.append(r)
					valid_next_direction = 2
		
	# DOWN	
	if direction == 2:
		for r in possible_next_rooms:
			for t in r.transfer_points:
				if t.direction == 1:
					valid_next_rooms.append(r)
					valid_next_direction = 1
		
	# LEFT
	if direction == 3:
		for r in possible_next_rooms:
			for t in r.transfer_points:
				if t.direction == 4:
					valid_next_rooms.append(r)
					valid_next_direction = 4
		
	# RIGHT
	if direction == 4:
		for r in possible_next_rooms:
			for t in r.transfer_points:
				if t.direction == 3:
					valid_next_rooms.append(r)
					valid_next_direction = 3
	
	if valid_next_rooms.size() > 0:
		var next_room = valid_next_rooms[randi() % valid_next_rooms.size()]
		var next_transfer_point
		
		for t in next_room.transfer_points:
			if t.direction == valid_next_direction:
				next_transfer_point = t
		
		# clear out the current room before switching over to the new one
		current_room.reset_room()
		# transfer the player to the next transfer point in the next room
		current_room = next_room
		RoomManager.transfer_player(next_room, next_transfer_point)
		
		initialize_current_room()
	else:
		print("No valid possibilites for the next room.")
		
func initialize_current_room():
	# first, make sure all other rooms are not visible and all transfer points
	# are disabled	
	for r in rooms:
		r.set_enabled(false)
			
	# set the new room to visible and all the transfer points to enabled
	current_room.set_enabled(true)
	
	load_items()
	load_enemies()
	
func load_items():
	if items:
		for i in items:
			# roll and compare that against the probability of
			# getting the item in the current room
			if (randi() % 100 + 1) <= i.probability:
				spawn_item(i)
	else:
		print("No items could be found for this era.")
	
func load_enemies():
	if enemies:
		for e in enemies:
			# roll and compare that against the probability of
			# getting the enemy in the current room
			if (randi() % 100 + 1) <= e.probability:
				spawn_enemy(e)
	else:
		print("No enemies could be found for this era.")
		
func spawn_item(item):
	var item_scene
	
	for i in ItemManager.items:
		if i.name == item.name:
			item_scene = load(i.scene)
	
	if item_scene:
		# roll to see how many we need to instance
		var roll = round(rand_range(item.quantity_min, item.quantity_max))
		
		var i = 0
		while i < roll:
			# instance the item, add it to the appropriate node
			# in the current room, then set the global position to a random point
			# in the area where the player can walk
			var item_instance = item_scene.instance()
			current_room.items.add_child(item_instance)
			item_instance.set_global_position(current_room.get_global_position())
			
			i = i + 1
		
		print("Spawned " + str(roll) + " " + item.name + "(s)")
	else:
		print("Item could not be found.")
		
func spawn_enemy(enemy):
	var enemy_scene
	
	for e in EnemyManager.enemies:
		if e.name == enemy.name:
			enemy_scene = load(e.scene)
	
	if enemy_scene:
		# roll to see how many we need to instance
		var roll = round(rand_range(enemy.quantity_min, enemy.quantity_max))
		
		var i = 0
		while i < roll:
			# instance the item, add it to the appropriate node
			# in the current room, then set the global position to a random point
			# in the area where the player can walk
			var enemy_instance = enemy_scene.instance()
			current_room.characters.add_child(enemy_instance)
			enemy_instance.set_global_position(current_room.get_global_position())
			
			i = i + 1
		
		print("Spawned " + str(roll) + " " + enemy.name + "(s)")
	else:
		print("Enemy could not be found.")
	
