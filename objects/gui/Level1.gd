extends Node2D

const MAP_PROCESSOR = preload("res://objects/map/MapProcessor.gd")
const APPLE = preload("res://assets/icons/food/apple.png")
const EGG = preload("res://assets/icons/food/egg.png")

const WIN_POINTS = 3

func find_point_by_position(points, pos):
	for p in points:
		if p.position == pos:
			return p
	return null

func random_win_path(points, start_point = points[randi() % points.size()], visited = Array()):
	visited.append(start_point)
	if visited.size() == WIN_POINTS:
		return visited

	# Find nearby points
	var adjacent_points = Array()
	for p in start_point.get_points():
		adjacent_points.append(find_point_by_position(points, p.position))

	# Remove visited points
	for p in visited:
		adjacent_points.remove(adjacent_points.find(p))

	# Ensure we have movement left
	if adjacent_points.size() > 0:
		return random_win_path(points, adjacent_points[randi() % adjacent_points.size()], visited)
	# If not restart algorithm
	else:
		visited.clear()
		return random_win_path(points)

func draw_line(p1, p2, color = Color(0,0,1)):
	var line = Line2D.new()
	line.default_color = color
	line.add_point(p1.position)
	line.add_point(p2.position)
	add_child(line)

func _ready():
	var mp = MAP_PROCESSOR.new()
	var points = mp.foo(self, $path.get_children())

	for point in points:
		$points.add_child(point)

		var s = Sprite.new()
		s.texture = APPLE
		s.scale = Vector2(0.2, 0.2)
		s.position = point.position
		add_child(s)

#		if point.left:
#			draw_line(point, point.left)
#		if point.right:
#			draw_line(point, point.right)
#		if point.up:
#			draw_line(point, point.up)
#		if point.down:
#			draw_line(point, point.down)

	randomize()
	var win_path = random_win_path(points)
	for p in win_path:
		var s = Sprite.new()
		s.texture = EGG
		s.scale = Vector2(0.2, 0.2)
		s.position = p.position
		add_child(s)
	print(win_path)
