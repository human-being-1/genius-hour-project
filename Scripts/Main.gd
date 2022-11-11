extends Node

var mobs = [load("res://Scenes/Mob.tscn")]
var wave = 1
var min_speed = 100.0
var max_speed = 150.0

func _ready():
	randomize()


func game_over():
	$HUD.show_message("Game Over!")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$MobTimer.stop()
	$WaveTimer.stop()
	$Player.hide()
	$Player.health = 6
	
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	
	yield($HUD/TitleTimer, "timeout")
	$Background.color = Color8(0, 60, 100)
	mobs = [load("res://Scenes/Mob.tscn")]
	wave = 1
	$HUD.update_wave(wave)
	min_speed = 100.0
	max_speed = 150.0
	
	$HUD/WaveLabel.hide()
	$HUD/ProgressBar.value = 6
	$HUD/ProgressBar.max_value = 6
	$HUD/ProgressBar.hide()
	$HUD/Title.text = "Attack of the Orbs"
	$HUD/Title.show()
	$HUD/StartButton.show()
	$HUD/CreditsLabel.show()
	

func new_game():
	$HUD.show_message("Get Ready!")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Player.show()
	$HUD.show()
	$StartTimer.start()


func _on_StartTimer_timeout():
	$MobTimer.start()
	$WaveTimer.start()

func _on_MobTimer_timeout():
	var mob
	if randi() % 45 == 0:
		mob = load("res://Scenes/MedPack.tscn").instance()
	else:
		mob = mobs[randi() % mobs.size()].instance()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnPosition")
	mob_spawn_location.offset = randi()
	
	mob.position = mob_spawn_location.position
	
	var direction = atan2(mob.position.direction_to($Player.position).y, mob.position.direction_to($Player.position).x)
	if not mob.direct:
		direction += rand_range(-PI / mob.accuracy, PI / mob.accuracy)
	
	var velocity = Vector2(rand_range(min_speed, max_speed) + mob.speed_modifier, 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child_below_node($Player, mob)


func _on_WaveTimer_timeout():
	$MobTimer.stop()
	
	wave += 1
	$HUD.update_wave(wave)
	
	if wave % 3 == 0:
		min_speed += 5.0
		max_speed += 5.0
	
	if $MobTimer.wait_time >= 0.55 and wave % 2 == 0:
		$MobTimer.wait_time -= 0.10
	
	if wave % 4 == 0:
		var modifier
		if wave <= 12: modifier = 2
		else: modifier = 1
		
		$Player.health += modifier
		$HUD/ProgressBar.max_value += modifier
		$HUD/ProgressBar.value = $Player.health
	
	match wave:
		4:
			$Background.color = Color8(0, 120, 60)
			mobs.append(load("res://Scenes/GreenMob.tscn"))
		8:
			$Background.color = Color8(150, 150, 70)
			mobs.append(load("res://Scenes/YellowMob.tscn"))
		12:
			$Background.color = Color8(70, 70, 150)
			mobs.append(load("res://Scenes/PurpleMob.tscn"))
		16:
			$Background.color = Color8(0, 75, 100)
			mobs.append(load("res://Scenes/TealMob.tscn"))
		20:
			$Background.color = Color8(200, 80, 0)
			mobs.append(load("res://Scenes/OrangeMob.tscn"))
	
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	#yield(get_tree().create_timer(1), "timeout")
	
	$MobTimer.start()


func _on_Player_hit():
	if $Player.health > $HUD/ProgressBar.max_value:
		$Player.health -= 1
	$HUD/ProgressBar.value = $Player.health
