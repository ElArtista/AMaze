extends Node

const NODE_ADD_PLAYER = preload("res://objects/gui/AddPlayerNode.tscn")

func add_new_add_node():
	var n = NODE_ADD_PLAYER.instance()
	n.connect("add_pressed", self, "_handle_add_player_pressed")
	$ScrollContainer/VBoxContainer.add_child(n)
	pass

#
# Callbacks
#
func _ready():
	add_new_add_node()

func _handle_add_player_pressed(name):
	add_new_add_node()
	print(name)

func _on_TextureButton_pressed():
	var names = Array()
	for i in $ScrollContainer/VBoxContainer.get_children():
		if !i.player_name.empty():
			names.append(i.player_name)

	if !names.empty():
		global.player_names = names
		get_tree().change_scene("res://scenes/menu/PregameStart.tscn")
