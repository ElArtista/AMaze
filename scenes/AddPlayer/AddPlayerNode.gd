extends HBoxContainer

signal add_pressed
var player_name

func _ready():
    add_constant_override("separation", 40)
    player_name = ""
    pass


func _on_AddButton_pressed():
    if !player_name.empty():
        emit_signal("add_pressed", player_name)
        remove_child($AddButton)
    else:
        print("No hi")

func _on_EditName_text_changed(new_text):
    player_name = $EditName.text
