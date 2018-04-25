extends Node

func _on_NewGameButton_pressed():
	$NewGameTimer.start()

func _on_CreditsButton_pressed():
	$CreditsTimer.start()

func _on_NewGameTimer_timeout():
	get_tree().change_scene("res://scenes/AddPlayer/PlayerCreation.tscn")

func _on_CreditsTimer_timeout():
	get_tree().change_scene("res://scenes/Credits.tscn")

func _on_ExitGame_pressed():
	get_tree().quit()
