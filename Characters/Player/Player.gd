extends Character

class_name Player

func _on_items_loaded():
	# equip a weapon for testing
	pass

func _process(delta):
	move_state(delta)
	
	# Arms will face the direction of the aim point
	armLeft.look_at(get_global_mouse_position())
	armRight.look_at(get_global_mouse_position())
	
	# Change the player's appearance based on where the mouse is looking
	if get_global_position().x > get_global_mouse_position().x:
		armRight.scale.y = -1
		armLeft.scale.y = -1
#		armRight.z_index = 20
#		armLeft.z_index = 10
#		weaponRight.show_behind_parent = true
#		weaponLeft.show_behind_parent = false
	else:
		armRight.scale.y = 1
		armLeft.scale.y = 1
#		armRight.z_index = 10
#		armLeft.z_index = 20
#		weaponRight.show_behind_parent = false
#		weaponLeft.show_behind_parent = true

func _input(_event):
	# Initiate interactions
	if Input.is_action_just_pressed("interact"):
		interactionManager.initiate_interaction()
		
	# Firing for not automatic weapons	
	if Input.is_action_just_pressed("fire"):
		if weaponLeft and not weaponLeft.is_automatic:
			weaponLeft.fire()
			
		if weaponRight and not weaponRight.is_automatic:
			weaponRight.fire()
		
	# Firing for automatic weapons		
	if Input.is_action_pressed("fire"):
		if weaponLeft and weaponLeft.is_automatic:
			weaponLeft.fire()
			
		if weaponRight and weaponRight.is_automatic:
			weaponRight.fire()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		
#		if input_vector.x > 0:
#			legRight.z_index = -20
#			legLeft.z_index = -10
#		else:
#			legRight.z_index = -10
#			legLeft.z_index = -20
		
		velocity = velocity.move_toward(input_vector * stats.max_speed, stats.acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
		
	move()
