extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var countdown = 5

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


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
