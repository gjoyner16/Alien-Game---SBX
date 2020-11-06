extends Node

signal enemies_loaded

var enemies

func _ready():
	# warning-ignore:return_value_discarded
	GameManager.connect("world_initialized", self, "_on_world_initialized")

func _on_world_initialized():
	load_enemies()
	
func load_enemies():
	var file = File.new()
	file.open("user://enemies.json", file.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json)
	file.close()

	enemies = json_result.get_result().get("enemies")
	
	if enemies:
		# need to wait a second so any scripts that use this can get connected
		yield(get_tree().create_timer(1), "timeout")
	
		emit_signal("enemies_loaded")
