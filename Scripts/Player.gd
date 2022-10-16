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

func _process(delta):
#	var velocity = Vector2.ZERO
#	if Input.is_action_pressed("move_up"):
#		velocity.y -= 1
#	if Input.is_action_pressed("move_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("move_down"):
#		velocity.y += 1
#	if Input.is_action_pressed("move_right"):
#		velocity.x += 1
#
#	if velocity.length() > 0:
#		velocity = velocity.normalized() * speed
	#	$Sprite.play()
	#else:
	#	$Sprite.stop()

	#position += velocity * delta
	position = get_viewport().get_mouse_position()
	position.x = clamp(position.x, 1, screen_size.x)
	position.y = clamp(position.y, 1, screen_size.y)
	
#	if velocity.x != 0:
#	#	$Sprite.animation = "walk"
#		$Sprite.flip_v = velocity.y > 0
#		$Sprite.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#	#	$Sprite.animation = "up"
#		$Sprite.flip_v = velocity.y > 0


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
			$CollisionShape2D.set_deferred("disabled", true)
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
