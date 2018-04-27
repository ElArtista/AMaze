extends Node2D

const MapPoint = preload("res://objects/map/MapPoint.gd")

const APPLE = preload("res://assets/icons/food/apple.png")

class PointSorterX:
	static func sort(a, b):
		var xa = abs(global.cur_point.position.x - a.position.x)
		var xb = abs(global.cur_point.position.x - b.position.x)
		if xa < xb:
			return true
		return false

class PointSorterY:
	static func sort(a, b):
		var ya = abs(global.cur_point.position.y - a.position.y)
		var yb = abs(global.cur_point.position.y - b.position.y)
		if ya < yb:
			return true
		return false

func draw_line(p1, p2, color = Color(0,0,1)):
	var line = Line2D.new()
	line.default_color = color
	line.add_point(p1.position)
	line.add_point(p2.position)
	add_child(line)

# Casts a ray from origin to target and returns true if it intersects a wall
func ray_cast_to_wall(origin, target):
	var mask = 4 # Collide ray with walls
	if target:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(origin.position, target.position, [self], mask)
		if result:
			draw_line(origin, target, Color(1,0,0)) # For debug
			return true
	return false

func _ready():
	# for each point find adjecnt points in all directions
	for point in $path.get_children():
		var px = point.position.x
		var py = point.position.y

		# Divide points to categories based on their location
		var threshold = 5 # search threshold in pixels
		var left_points = Array()
		var right_points = Array()
		var up_points = Array()
		var down_points = Array()
		for point2 in $path.get_children():
			if point == point2: # Skip self
				continue

			if abs(point2.position.x - px) <= threshold:
				if point2.position.y > py:
					down_points.append(point2)
				else:
					up_points.append(point2)
			elif abs(point2.position.y - py) <= threshold:
				if point2.position.x > px:
					right_points.append(point2)
				else:
					left_points.append(point2)

		# Find adjecent points
		global.cur_point = point
		left_points.sort_custom(PointSorterX, "sort")
		right_points.sort_custom(PointSorterX, "sort")
		up_points.sort_custom(PointSorterY, "sort")
		down_points.sort_custom(PointSorterY, "sort")
		var left = left_points[0] if left_points.size() > 0 else null
		var right = right_points[0] if right_points.size() > 0 else null
		var up = up_points[0] if up_points.size() > 0 else null
		var down = down_points[0] if down_points.size() > 0 else null

		# Raycast to check if there is a wall in between
		if ray_cast_to_wall(point, left):
			left = null
		if ray_cast_to_wall(point, right):
			right = null
		if ray_cast_to_wall(point, up):
			up = null
		if ray_cast_to_wall(point, down):
			down = null

		# Construct map point
		var mpoint = MapPoint.new(point)
		mpoint.left = left
		mpoint.right = right
		mpoint.up = up
		mpoint.down = down
		$points.add_child(mpoint)

		var s = Sprite.new()
		s.texture = APPLE
		s.scale = Vector2(0.2, 0.2)
		s.position = point.position
		add_child(s)

	for mpoint in $points.get_children():
		if mpoint.left:
			draw_line(mpoint, mpoint.left)
		if mpoint.right:
			draw_line(mpoint, mpoint.right)
		if mpoint.up:
			draw_line(mpoint, mpoint.up)
		if mpoint.down:
			draw_line(mpoint, mpoint.down)