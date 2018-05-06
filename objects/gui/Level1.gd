extends Node2D

const MAP_PROCESSOR = preload("res://objects/map/MapProcessor.gd")
const APPLE = preload("res://assets/icons/food/apple.png")

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

		if point.left:
			draw_line(point, point.left)
		if point.right:
			draw_line(point, point.right)
		if point.up:
			draw_line(point, point.up)
		if point.down:
			draw_line(point, point.down)
