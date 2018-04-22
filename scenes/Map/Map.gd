extends Node2D

var item_scene = preload("res://scenes/Map/Item.tscn")

var path_points = Array()
var item_points = Array()

func new_item(name, pos):
    var i = item_scene.instance()
    i.init(name)
    i.position = pos
    return i

func new_sprite(texture, pos):
    var s = Sprite.new()
    s.texture = texture
    s.position = pos
    return s

func remove_item(item):
    remove_child(item)

func _ready():
    for i in $PATH.get_children():
        path_points.append(i.position)
        add_child(new_sprite(load("res://assets/icon.png"), i.position))
        
    var types = item_scene.instance().TYPES
    for i in $DIAMONDS.get_children():
        item_points.append(i.position)
        var r = randi() % types.size()
        var s = new_item(types[r], i.position)
        s.scale = Vector2(0.13, 0.13)
        add_child(s)
