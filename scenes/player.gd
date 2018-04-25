extends KinematicBody2D

const Item = preload("Map/Item.gd")
#onready var item = Item.new()

signal on_collide_with_item(item)

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

func _physics_process(delta):
	if checkpoints.size() > 0:
		var target_pt = checkpoints[0]
		var eps = 10 # Threshold in pixels
		var dir = target_pt - position
		if dir.length() > eps:
			var velocity = dir.normalized() * SPEED

			var collision_info = move_and_collide(velocity * delta)
			if collision_info:
				if collision_info.collider is Item:
					emit_signal("on_collide_with_item", collision_info.collider)

			if (abs(velocity.x) > abs(velocity.y)):
				$AnimatedSprite.animation = "right"
				$AnimatedSprite.flip_h = velocity.x < 0
			else:
				$AnimatedSprite.animation = "down"
			$AnimatedSprite.play()
		else:
			position = target_pt
			checkpoints.pop_front()
			$AnimatedSprite.animation = "idle"
			$AnimatedSprite.stop()
