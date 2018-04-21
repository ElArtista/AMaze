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
	# Create player
	player = Player.instance()
	add_child(player)
	# Gather path nodes and try to put them in order
	var path_nodes = $Background/PATH.get_children()
	path_nodes.sort_custom(NameSorter, "sort")
	path_nodes.invert()
	# Make player traverse the nodes
	for pn in path_nodes:
		player.add_checkpoint(pn.position)