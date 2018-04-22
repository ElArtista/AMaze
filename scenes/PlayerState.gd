extends Node

signal on_game_over
signal on_win(items)

const MAX_ITEMS = 4

var prev_items = Array()
var items = Array()
var player_name = ""

func add_new_item(item):
    items.append(item)
    if items.size() <= prev_items.size():
        if item != prev_items[items.size() - 1]:
            emit_signal("on_game_over")
    elif items.size() == MAX_ITEMS:
        emit_signal("on_win", items)
