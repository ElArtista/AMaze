extends Node

func _on_TryAgainButton_pressed():
	$TransitionTimer.start()

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_TransitionTimer_timeout():
	get_tree().change_scene("res://scenes/PregameStart.tscn")

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
