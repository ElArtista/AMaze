extends Node2D

var egg = load("res://assets/icons/food/egg.png")
var apple = load("res://assets/icons/food/apple.png")
var candy = load("res://assets/icons/food/candy.png")
var grape = load("res://assets/icons/food/grape.png")
var lemon = load("res://assets/icons/food/lemon.png")
var carrot = load("res://assets/icons/food/carrot.png")
var eggplant = load("res://assets/icons/food/eggplant.png")
var icons = [egg, apple, candy, grape, lemon, carrot, eggplant]

var path_points = Array()
var item_points = Array()

func new_sprite(texture, pos):
    var s = Sprite.new()
    s.texture = texture
    s.position = pos
    return s

func _ready():
    for i in $PATH.get_children():
        path_points.append(i.position)
        add_child(new_sprite(load("res://assets/icon.png"), i.position))
        
    for i in $DIAMONDS.get_children():
        item_points.append(i.position)
        var r = randi() % icons.size()
        var s = new_sprite(icons[r], i.position)
        s.scale = Vector2(0.13, 0.13)
        add_child(s)
