extends Node

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_tree().change_scene("res://scenes/MainMenu.tscn")
