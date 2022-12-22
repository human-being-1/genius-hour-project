extends RigidBody2D

var powerup = false
var shield = true
var speed_modifier = 0
var direct = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
