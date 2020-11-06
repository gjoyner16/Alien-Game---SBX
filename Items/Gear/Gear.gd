extends Item

class_name Gear

export(GearPosition) var position
export var armor: int
export var max_hp: int

func _ready():
	# get our base weapon information and update this weapons stats	
	for i in ItemManager.items:
		if i.name == self.name:
			position = i.position
			max_hp = i.gear.max_hp
			armor = i.gear.armor

