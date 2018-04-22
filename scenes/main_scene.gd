extends Node

export (PackedScene) var Player
var player
var graph

class NameSorter:
	static func sort(a, b):
		if a.get_name() < b.get_name():
			return true
		return false

class Pair:
	var things = [null, null]
	func _init(t1, t2):
		things = [t1, t2]
	func has(t):
		return t in things
	func other(t):
		if t == things[0]:
			return things[1]
		elif t == things[1]:
			return things[0]
		else:
			return null
	func to_string():
		return "Pair{" + str(things[0]) + "," + str(things[1]) + "}"

class StepGraph:
	var V = [] # Vertices
	var E = [] # Edges
	func get_adjacent_verts(v):
		var idx = V.find(v)
		if idx == -1:
			return null
		var adj_verts = []
		for p in E:
			if p.has(idx):
				adj_verts.push_back(V[p.other(idx)])
		return adj_verts
	func print():
		for v in V:
			print("Vert: ", v)
		for e in E:
			print("Adj: ", e.to_string())

func lines_intersect(p0_x, p0_y, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y):
	var s1_x = p1_x - p0_x
	var s1_y = p1_y - p0_y
	var s2_x = p3_x - p2_x
	var s2_y = p3_y - p2_y
	var s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y + 0.000001);
	var t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y + 0.000001);
	if s >= 0 && s <= 1 && t >= 0 && t <= 1:
		return true
	return false

func line_intersects_path(v1, v2, path):
	var curve = path.curve
	for i in range(curve.get_point_count() - 1):
		var p1 = curve.get_point_position(i)
		var p2 = curve.get_point_position(i + 1)
		if lines_intersect(v1.x, v1.y, v2.x, v2.y, p1.x, p1.y, p2.x, p2.y):
			return true
	return false

func path_points_adjacent(v1, v2, walls):
	# Check for any wall between
	for w in walls:
		if line_intersects_path(v1, v2, w):
			return false
	var e = 10 # epsilon = 10 pixels
	# WARNIN: HAckalicius code bellow
	# Check that horizontal or vertical offsets are small
	return (abs(v1.x - v2.x) < e or abs(v1.y - v2.y) < e)

func create_graph(verts, walls):
	var G = StepGraph.new()
	G.V = verts
	for i in range(verts.size()):
		for j in range(verts.size()):
			if i != j:
				var v1 = verts[i].position
				var v2 = verts[j].position
				if path_points_adjacent(v1, v2, walls):
					G.E.push_back(Pair.new(i, j))
	return G

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			player.add_checkpoint(event.position)

func _ready():
	# Seed the random generator
	randomize()
	# Create player
	player = Player.instance()
	add_child(player)
	# Gather path nodes and try to put them in order
	var path_nodes = $Background/PATH.get_children()
	path_nodes.sort_custom(NameSorter, "sort")
	path_nodes.invert()
	# Gather wall Path2D's
	var walls = $Walls.get_children()
	# Generate adjustency graph
	graph = create_graph(path_nodes, walls)
	graph.print()
	# Random starting point
	var p = graph.V[randi() % graph.V.size()]
	# Make player traverse the path randomly for 500 steps
	for i in range(500):
		var adjustent_points = graph.get_adjacent_verts(p)
		p = adjustent_points[randi() % adjustent_points.size()]
		player.add_checkpoint(p.position)