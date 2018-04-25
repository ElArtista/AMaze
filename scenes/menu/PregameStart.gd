extends Node

const PlayerState = preload("res://objects/player/PlayerState.gd")
const Item = preload("res://objects/Item.gd")

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var countdown = 5

func _ready():
	if !global.player_state:
		global.player_state = PlayerState.new()
		global.player_state.prev_items = ["Egg", "Lemon", "Eggplant"]
	global.player_state.player_name = global.player_names[global.player_idx]

	var t1 = Item.type_to_texture(global.player_state.prev_items[0])
	var t2 = Item.type_to_texture(global.player_state.prev_items[1])
	var t3 = Item.type_to_texture(global.player_state.prev_items[2])
	$ItemContainer/FirstItem.texture = t1
	$ItemContainer/SecondItem.texture = t2
	$ItemContainer/ThirdItem.texture = t3

func _on_Timer_timeout():
	if countdown >= 1:
		countdown -= 1
		if countdown == 0:
			$TimerLabel.text = "Πάμε!"
			$TransitionTimer.start()
		else:
			$TimerLabel.text = str(countdown)
	else:
		pass

func _on_TransitionTimer_timeout():
	get_tree().change_scene("res://scenes/MainScene.tscn")
