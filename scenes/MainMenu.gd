extends Node

func _ready():
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
    pass

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
