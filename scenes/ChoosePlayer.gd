extends Node

var player_names = Array()

func _ready():
	###
	# Mockup TODO: Remove
	player_names.clear()
	player_names.append("Dimitris")
	player_names.append("Luke")
	player_names.append("Nick")
	###

func choose_next_player():
	var sz = player_names.size()
	if sz > 0:
	    var i = randi() % sz
	    return player_names[i]
	else:
	    return ""

func _on_TextureButton_pressed():
	print(choose_next_player())
