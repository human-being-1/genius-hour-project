extends RigidBody2D
var speed_modifier = 0
var accuracy = 6
export var health_added = 1

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
