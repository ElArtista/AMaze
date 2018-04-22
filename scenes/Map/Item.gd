extends StaticBody2D

export(Texture) var texture setget set_texture

const TYPES = ["Egg", "Apple", "Candy", "Grape", "Lemon", "Carrot", "Eggplant"]
var type = ""

var egg = load("res://assets/icons/food/egg.png")
var apple = load("res://assets/icons/food/apple.png")
var candy = load("res://assets/icons/food/candy.png")
var grape = load("res://assets/icons/food/grape.png")
var lemon = load("res://assets/icons/food/lemon.png")
var carrot = load("res://assets/icons/food/carrot.png")
var eggplant = load("res://assets/icons/food/eggplant.png")

#
# Initialize Item
# @t: String to represent this item's type. Choose from TYPES
#
func init(t):
    type = t
    if type == "Egg":
        texture = egg
    elif type == "Apple":
        texture = apple
    elif type == "Candy":
        texture = candy
    elif type == "Grape":
        texture = grape
    elif type == "Lemon":
        texture = lemon
    elif type == "Carrot":
        texture = carrot
    elif type == "Eggplant":
        texture = eggplant

    #set_texture(texture)

func _ready():
    set_texture(texture)

func set_texture(t):
    texture = t
    if ($Sprite != null):
        $Sprite.texture = texture