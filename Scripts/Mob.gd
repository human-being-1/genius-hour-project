extends RigidBody2D
export var damage = 1
export var speed_modifier = 0

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()