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

func hack_graph(verts):
	var G = StepGraph.new()
	G.V = verts
	for i in range(verts.size()):
		for j in range(verts.size()):
			if i != j:
				var v1 = verts[i].position
				var v2 = verts[j].position
				var e = 10 # epsilon = 10 pixels
				# WARNIN: HAckalicius code bellow
				# Check that horizontal or vertical offsets are small
				if abs(v1.x - v2.x) < e or abs(v1.y - v2.y) < e:
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
	# Generate adjustency graph
	graph = hack_graph(path_nodes)
	graph.print()
	# Choose a path randomly
	#var paths = $Paths.get_children()
	#var sample_path = paths[randi() % paths.size()].curve
	# Random starting point
	var p = graph.V[randi() % graph.V.size()]
	# Make player traverse the path randomly for 500 steps
	for i in range(500):
		var adjustent_points = graph.get_adjacent_verts(p)
		p = adjustent_points[randi() % adjustent_points.size()]
		player.add_checkpoint(p.position)