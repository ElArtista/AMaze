extends Node

export (PackedScene) var Player
var player

class NameSorter:
	static func sort(a, b):
		if a.get_name() < b.get_name():
			return true
		return false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			player.add_checkpoint(event.position)

func _ready():
	# Seed the random generator
	randomize()
	# Create player
	player = Player.instance()
	add_child(player)
	# Choose a path randomly
	var paths = $Paths.get_children()
	var sample_path = paths[randi() % paths.size()].curve
	# Make player traverse the path
	for i in range(sample_path.get_point_count()):
		player.add_checkpoint(sample_path.get_point_position(i))