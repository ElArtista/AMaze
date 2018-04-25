extends Node

var AddPlayerNodeScene

func add_new_add_node():
	var n = AddPlayerNodeScene.instance()
	n.connect("add_pressed", self, "_handle_add_player_pressed")
	$ScrollContainer/VBoxContainer.add_child(n)
	pass

#
# Callbacks
#
func _ready():
	AddPlayerNodeScene = preload("res://scenes/AddPlayer/AddPlayerNode.tscn")
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
		get_tree().change_scene("res://scenes/PregameStart.tscn")
