extends RigidBody2D
var powerup = true
var speed_modifier = 0
var direct = true
export var health_added = 1

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
