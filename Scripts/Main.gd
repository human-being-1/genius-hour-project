extends Node

var mobs = [load("res://Scenes/Mob.tscn")]
var wave = 1
var min_speed = 100.0
var max_speed = 150.0

func _ready():
	randomize()
	new_game()

func game_over():
	$MobTimer.stop()
	$WaveTimer.stop()
	$Player.hide()
	
	get_tree().call_group("mobs", "queue_free")
	

func new_game():
	$Player.show()
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_StartTimer_timeout():
	print("Wave 1")
	$MobTimer.start()
	$WaveTimer.start()

func _on_MobTimer_timeout():
	var mob
	if randi() % 100 == 0:
		mob = load("res://Scenes/MedPack.tscn").instance()
	else:
		mob = mobs[randi() % mobs.size()].instance()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnPosition")
	mob_spawn_location.offset = randi()
	
	mob.position = mob_spawn_location.position
	
	var direction = atan2(mob.position.direction_to($Player.position).y, mob.position.direction_to($Player.position).x)
	direction += rand_range(-PI / mob.accuracy, PI / mob.accuracy)
	
	var velocity = Vector2(rand_range(min_speed, max_speed) + mob.speed_modifier, 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child_below_node($Player, mob)


func _on_WaveTimer_timeout():
	$MobTimer.stop()
	
	wave += 1
	print("Wave " + str(wave))
	$HUD/WaveLabel.text = "Wave " + str(wave)
	
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
			mobs.append(load("res://Scenes/GreenMob.tscn"))
		8:
			mobs.append(load("res://Scenes/YellowMob.tscn"))
		12:
			mobs.append(load("res://Scenes/PurpleMob.tscn"))
		16:
			mobs.append(load("res://Scenes/TealMob.tscn"))
		20:
			mobs.append(load("res://Scenes/OrangeMob.tscn"))
	
	get_tree().call_group("mobs", "queue_free")
	#yield(get_tree().create_timer(1), "timeout")
	
	$MobTimer.start()


func _on_Player_hit():
	if $Player.health > $HUD/ProgressBar.max_value:
		$Player.health -= 1
	$HUD/ProgressBar.value = $Player.health
