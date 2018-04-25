extends Node

const PlayerState = preload("res://objects/player/PlayerState.gd")

export (PackedScene) var Player
var player
var graph
const NUM_WIN_ITEMS = 3

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

func static_body2d_to_path(o):
	var poly = o.get_children()[0].polygon
	var origin = o.position
	var path = []
	path.append(origin)
	for i in range(poly.size()):
		path.append(origin + poly[i])
	return path

func line_intersects_path(v1, v2, path):
	for i in range(path.size() - 1):
		var p1 = path[i]
		var p2 = path[i + 1]
		print("p1: ", p1, " p2: ", p2)
		if lines_intersect(v1.x, v1.y, v2.x, v2.y, p1.x, p1.y, p2.x, p2.y):
			return true
	return false

func path_points_adjacent(v1, v2, walls):
	# Check for any wall between
	for w in walls:
		var p = static_body2d_to_path(w)
		if line_intersects_path(v1, v2, p):
			return false
	var e = 15 # epsilon = 10 pixels
	# WARNIN: HAckalicius code bellow
	# Check that horizontal or vertical offsets are small
	return (abs(v1.x - v2.x) < e or abs(v1.y - v2.y) < e)

func create_graph(verts, walls):
	var G = StepGraph.new()
	G.V = verts
	for i in range(verts.size()):
		for j in range(verts.size()):
			if i != j:
				var v1 = verts[i]
				var v2 = verts[j]
				if path_points_adjacent(v1, v2, walls):
					G.E.push_back(Pair.new(i, j))
	return G

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			# Try to move player if on a graph vertex
			if player.position in graph.V:
				var adjustent_points = graph.get_adjacent_verts(player.position)
				for ap in adjustent_points:
					var hit_radius = 30
					if (ap - event.position).length() < hit_radius:
						player.add_checkpoint(ap)
						return

func next_player(name, items):
	global.player_state.player_name = name
	global.player_state.prev_items = items
	global.player_state.items = Array()
	print("Next Player!")
	print(items)
	get_tree().change_scene("res://scenes/menu/PregameStart.tscn")

func square_distance_pt_segment(a, b, p):
	var n = b - a
	var pa = a - p
	var c = n.dot(pa)
	# Closest point is a
	if c > 0.0:
		return pa.dot(pa)
	var bp = p - b
	# Closest point is b
	if n.dot(bp) > 0.0:
		return bp.dot(bp)
	# Closest point is between a and b
	var e = pa - n * (c / n.dot(n))
	return e.dot(e)

func _ready():
	# Setup player state
	global.player_state.connect("on_game_over", self, "_handle_on_game_over")
	global.player_state.connect("on_win", self, "_handle_on_win")

	# Seed the random generator
	randomize()

	# Start BGM
	$BGM.playing = true

	# Create player
	player = Player.instance()
	player.connect("on_collide_with_item", self, "_handle_player_hit_item")
	add_child(player)

	# Gather path nodes and try to put them in order
	var path_nodes = $Map/path.get_children()
	path_nodes.sort_custom(NameSorter, "sort")
	path_nodes.invert()
	var path_points = []
	for pn in path_nodes:
		path_points.push_back(pn.position)
	# Gather wall Path2D's
	var walls = $Map/walls.get_children()
	# Generate adjustency graph
	graph = create_graph(path_points, walls)
	graph.print()

	# Random starting point
	var p = graph.V[randi() % graph.V.size()]
	player.add_checkpoint(p)

	# Random path from starting point
	var winning_gems = []
	var winnning_path = [].append(p)
	while winning_gems.size() < NUM_WIN_ITEMS:
		var adjustent_points = graph.get_adjacent_verts(p)
		var rp = adjustent_points[randi() % adjustent_points.size()]
		for d in $Map/diamonds.get_children():
			if sqrt(square_distance_pt_segment(p, rp, d.position)) < 20:
				if not (d.position in winning_gems):
					winning_gems.append(d.position)
					break
		p = rp

	# Generate items
	var item_scene = $Map.item_scene
	var types = item_scene.instance().TYPES
	var winning_item_types = Array()
	for i in global.player_state.prev_items:
		winning_item_types.append(types.find(i))
	var item_points = $Map.item_points
	for i in $Map/diamonds.get_children():
		item_points.append(i.position)
		var r = randi() % types.size()
		if i.position in winning_gems:
			var idx = winning_gems.find(i.position)
			r = winning_item_types[idx]
		var s = $Map.new_item(types[r], i.position)
		s.scale = Vector2(0.25, 0.25)
		$Map.add_child(s)

func _handle_player_hit_item(item):
	$Map.remove_item(item)
	global.player_state.add_new_item(item.type)
	print(item.type)

func _handle_on_game_over():
	get_tree().quit()
	print("Game Over")

func _handle_on_win(items):
	items.pop_front()
	if global.player_idx < global.player_names.size() - 1:
		global.player_idx += 1
	else:
		global.player_idx = 0

	next_player(global.player_names[global.player_idx], items)
