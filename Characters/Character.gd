extends KinematicBody2D

class_name Character

# stats and movement
onready var stats = $Stats
var velocity = Vector2.ZERO

# sprite and animation
onready var armLeft = $Torso/ArmLeft
onready var armRight = $Torso/ArmRight
onready var legLeft = $Torso/LegLeft
onready var legRight = $Torso/LegRight
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# gear
onready var equipmentArmLeft = $Torso/ArmLeft/EquipmentArmLeft
onready var equipmentArmRight = $Torso/ArmRight/EquipmentArmRight
onready var equipmentTorso = $Torso/EquipmentTorso
onready var equipmentLegLeft = $Torso/LegLeft/EquipmentLegLeft
onready var equipmentLegRight = $Torso/LegRight/EquipmentLegRight
onready var equipmentFootLeft = $Torso/LegLeft/EquipmentFootLeft
onready var equipmentFootRight = $Torso/LegRight/EquipmentFootRight

# gear instances when we have something equipped
var equipment: Dictionary
var weaponLeft
var weaponRight
var gearTorso
var gearLegLeft
var gearLegRight
var gearFootLeft
var gearFootRight

# other
onready var interactionManager = $InteractionManager

func _ready():
	# warning-ignore:return_value_discarded
	ItemManager.connect("items_loaded", self, "_on_items_loaded")	
	
func _on_items_loaded():
	pass

func _process(delta):
	move_state(delta)

func _input(_event):
	pass

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		
		velocity = velocity.move_toward(input_vector * stats.max_speed, stats.acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
		
	move()

func move():
	velocity = move_and_slide(velocity)
	
func update_equipment():
	# reset our equipment array	
	equipment.clear()
	
	# add the equipment in each slot to this array
	equipment = {"weaponLeft": weaponLeft,
				 "weaponRight": weaponRight,
				 "gearTorso": gearTorso,
				 "gearLegLeft": gearLegLeft,
				 "gearLegRight": gearLegRight,
				 "gearFootLeft": gearFootLeft,
				 "gearFootRight": gearFootRight}
	
func _on_Stats_no_health():
	print(name + " has died.")
	# replace with an actual death scenario	
