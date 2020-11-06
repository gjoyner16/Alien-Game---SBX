extends Node

class_name Item

enum ItemType { WEAPON, GEAR, INGREDIENT }
enum WeaponType { MAIN, OFFHAND }
enum GearPosition { TORSO, HEAD, ARM_LEFT, ARM_RIGHT, LEG_LEFT, LEG_RIGHT, FOOT_LEFT, FOOT_RIGHT }

var character setget set_character, get_character

func _ready():
	pass # Replace with function body.
	
func set_character(new_char):
	character = new_char
	
func get_character():
	return character

