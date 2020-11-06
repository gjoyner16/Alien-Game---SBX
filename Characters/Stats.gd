extends Node

class_name Stats

signal no_health

# base stats
export var BASE_MAX_HP = 1
export var BASE_ARMOR = 0
export var BASE_ACCELERATION = 1000
export var BASE_MAX_SPEED = 320
export var BASE_FRICTION = 500
var modifiers : Array

# hp
var max_hp
var hp = 0

# armor
var armor

# movement
var acceleration
var max_speed
var friction

func _ready():
	# initialize the character with base stats
	set_stat("max_hp", BASE_MAX_HP)
	set_stat("armor", BASE_ARMOR)
	set_stat("acceleration", BASE_ACCELERATION)
	set_stat("max_speed", BASE_MAX_SPEED)
	set_stat("friction", BASE_FRICTION)
	
	# test
	apply_modifier("Overalls_TORSO", "max_hp", "*", 2)
#	remove_modifier("max_hp")	

func set_stat(stat, num):
	set(stat, num)
	
	# if we're changing our max hp, we need to change our hp too	
	if stat == "max_hp":	
		set_hp(num)
	
func set_hp(num):
	# need to check if this is going to kill the character first	
	var new_hp = hp + num
	
	if new_hp <= 0:
		# character will be dead with this health adjustment		
		emit_signal("no_health")		
	else:
		# we can adjust the health down
		hp = hp + num
		
func apply_modifier(item, stat, operator, num):
	var calc_value = 0
	
	if operator == "+":
		calc_value = num
	elif operator == "*":
		calc_value = get(stat) * num
		
	# get what our original 	
	var new_value = get(stat) + calc_value
	
	if new_value:
		set(stat, new_value)
		modifiers.append({"item":item, "stat":stat, "value":calc_value})
		print(operator + str(num) + " " + stat + " modifier applied. New total: " + str(new_value))
	else:
		print("Could not calculate stat modifier.")

func remove_modifier(item):
	for m in modifiers:
		if m.get("item") == item:
			# adjust the stat
			var stat = m.get("stat")
			var new_value = get(stat) - m.get("value")
			set(stat, new_value)
			# remove from the modifers list
			modifiers.erase(m)
#			print(stat + " modifier removed. New total: " + str(new_value))
