extends Area2D

export (int) var SPEED
var checkpoints = []
var placed

func _ready():
	placed = false

func add_checkpoint(cp):
	if not placed:
		position = cp
		placed = true
	else:
		checkpoints.push_back(cp)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if checkpoints.size() > 0:
		var target_pt = checkpoints[0]
		var eps = 5
		var dir = target_pt - position
		if dir.length() > eps:
			var velocity = dir.normalized() * SPEED
			position += velocity * delta
			$AnimatedSprite.animation = "right"
			$AnimatedSprite.flip_h = velocity.x < 0
			$AnimatedSprite.play()
		else:
			checkpoints.pop_front()
			$AnimatedSprite.animation = "idle"
			$AnimatedSprite.stop()