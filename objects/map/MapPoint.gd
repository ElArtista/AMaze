tool
extends Position2D

var left = null
var right = null
var up = null
var down = null

# @node: A Position2D
func _init(node):
	#self = node.duplicate()
	position = node.position
	pass

func get_points():
	var p = Array()
	if left != null:
		p.append(left)
	if right != null:
		p.append(right)
	if up != null:
		p.append(up)
	if down != null:
		p.append(down)
	return p