extends StaticBody2D

export(Texture) var texture setget set_texture

const TYPES = ["Egg", "Apple", "Candy", "Grape", "Lemon", "Carrot", "Eggplant"]
var type = ""

const egg = preload("res://assets/icons/food/egg.png")
const apple = preload("res://assets/icons/food/apple.png")
const candy = preload("res://assets/icons/food/candy.png")
const grape = preload("res://assets/icons/food/grape.png")
const lemon = preload("res://assets/icons/food/lemon.png")
const carrot = preload("res://assets/icons/food/carrot.png")
const eggplant = preload("res://assets/icons/food/eggplant.png")

static func type_to_texture(t):
    if t == "Egg":
        return egg
    elif t == "Apple":
        return apple
    elif t == "Candy":
        return candy
    elif t == "Grape":
        return grape
    elif t == "Lemon":
        return lemon
    elif t == "Carrot":
        return carrot
    elif t == "Eggplant":
        return eggplant
    else:
        return null

#
# Initialize Item
# @t: String to represent this item's type. Choose from TYPES
#
func init(t):
    type = t
    texture = type_to_texture(type)

func _ready():
    set_texture(texture)

func set_texture(t):
    texture = t
    if ($Sprite != null):
        $Sprite.texture = texture