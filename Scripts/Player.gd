extends Area2D
signal die
signal hit

export var speed = 175
var screen_size
var health = 6
var on_cooldown = false
var on_powerup_cooldown = false

func _ready():
	screen_size = get_viewport_rect().size

func _process(_delta):
	position = get_viewport().get_mouse_position()
	position.x = clamp(position.x, 1, screen_size.x)
	position.y = clamp(position.y, 1, screen_size.y)


func _on_Player_body_entered(body):
	if body.powerup and not on_powerup_cooldown:
		health += body.health_added
		emit_signal("hit")
		body.queue_free()
	if not body.powerup and not on_cooldown:
		health -= body.damage
		print(health)
		emit_signal("hit")
		if health <= 0:
			hide()
			emit_signal("die")
			return
		$AnimatedSprite.play("hurt")
		on_cooldown = true
		yield(get_tree().create_timer(1.5), "timeout")

		on_cooldown = false
		$AnimatedSprite.play("default")

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
