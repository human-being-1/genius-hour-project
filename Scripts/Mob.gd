extends RigidBody2D
export var damage = 1
export var speed_modifier = 0
export var accuracy = 6
export var direct = false
var powerup = false

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
