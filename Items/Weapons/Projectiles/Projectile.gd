extends RigidBody2D

class_name Projectile

#base stats
var damage = 0 setget set_damage

func _ready():
	pass
	
func set_damage(dmg):
	damage = dmg

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
