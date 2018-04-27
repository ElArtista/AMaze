extends Node

func post_import(scene):
	var node2d = Node2D.new()
	node2d.name = "points"
	scene.add_child(node2d)
	node2d.set_owner(scene)
	return scene