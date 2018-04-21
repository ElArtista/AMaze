extends Node2D

func _ready():
	for c in $PATH.get_children():
		var s = Sprite.new()
		s.texture = load("res://assets/icon.png")
		s.position.x = c.position.x
		s.position.y = c.position.y
		add_child(s)