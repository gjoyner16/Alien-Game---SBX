extends Node

var eras: Array
var target_era: Era
var current_era: Era

func _ready():
	# game manager needs to be loaded first	
	# warning-ignore:return_value_discarded
	GameManager.connect("world_initialized", self, "_on_world_initialized")
	
	# game manager needs to be loaded first	
	# warning-ignore:return_value_discarded
	ItemManager.connect("items_loaded", self, "_on_items_loaded")
	
func _on_world_initialized():
	# load in all of our possible eras
	for e in GameManager.eras.get_children():
		eras.append(e)
		
	# set the era to the first era for testing purposes
	target_era = eras[0]
	current_era = target_era
	
func _on_items_loaded():
	# loads item, enemy, enhancement information for each era from
	# a json file	
	load_eras()
	
func load_eras():
	# pull all the information from the file	
	var file = File.new()
	file.open("user://eras.json", file.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json)
	file.close()

	var eras_information = json_result.get_result().get("eras")
	
	# update the era information for each era
	for e in eras:
		for ei in eras_information:
			if e.name == ei.name:
				if ei.items:
					e.items = ei.items
					
				if ei.enemies:
					e.enemies = ei.enemies
	
func initiate_run(era):
	# initiate the run within the eras code
	era.start_run()
	
func next_room(direction):
	current_era.next_room(direction)
	
	
