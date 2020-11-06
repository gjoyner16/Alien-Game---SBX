extends Item

class_name Weapon

onready var firePosition = $Sprite/FirePosition
onready var waitTimer = $WaitTimer

export(WeaponType) var weapon_type
export var is_automatic: bool
export var projectile_scene: String
export var projectile_speed: int
export var fire_rate: float
export var damage: int

var projectile
var position: String
var is_waiting = false

func _ready():
	# get our base weapon information and update this weapons stats	
	for i in ItemManager.items:
		if i.name == self.name:
			weapon_type = i.weapon.weapon_type
			is_automatic = i.weapon.is_automatic
			projectile_scene = i.weapon.projectile_scene
			projectile_speed = i.weapon.projectile_speed
			fire_rate = i.weapon.fire_rate
			damage = i.weapon.damage

	# load our projectile scene once we've loaded our items json	
	if projectile_scene:
		projectile = load(projectile_scene)
		
func fire():
	# we can't fire if we don't have a projectile, this is a mistake
	if projectile:	
		# make sure we're not still waiting to fire	
		if not is_waiting:
			# create the projectile		
			var proj = projectile.instance()
			
			# add as a child of the current room node
			var room = RoomManager.active_room.get_node("Objects")
			room.add_child(proj)
			
			proj.set_global_position(firePosition.get_global_position())
			
			if position == "ARM_LEFT":
				proj.rotation = character.armLeft.rotation
				proj.apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(character.armLeft.rotation))
			else:
				proj.rotation = character.armRight.rotation
				proj.apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(character.armRight.rotation))
			
			proj.set_damage(damage)
				
			# set the timer so we have to wait to fire again
			is_waiting = true
			waitTimer.start(fire_rate)
	else:
		print("No projectile associated with this weapon.")


func _on_WaitTimer_timeout():
	# reset our wait bool so we can fire again	
	is_waiting = false
