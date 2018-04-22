extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			get_tree().change_scene("res://scenes/MainMenu.tscn")

#func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	#$CreditsNames/Names.rect_global_position.y += 60*delta


