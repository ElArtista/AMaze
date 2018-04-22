extends StaticBody2D

export(Texture) var texture setget set_texture

func _ready():
    set_texture(texture)

func set_texture(t):
    texture = t
    if ($Sprite != null):
        $Sprite.texture = texture