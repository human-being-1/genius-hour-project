extends CanvasLayer

signal start_game

func show_message(text):
	$Title.text = text
	$Title.show()
	$TitleTimer.start()
	
func game_over():
	show_message("Game Over")
	yield($TitleTimer, "timeout")
	
	$Title.text = "Attack of the Orbs"
	$Title.show()
	
	yield(get_tree().create_timer(1), "timeout")
	
func update_wave(wave):
	$WaveLabel.text = "Wave " + str(wave)


func _on_TitleTimer_timeout():
	$Title.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	$CreditsLabel.hide()
	$ProgressBar.show()
	$WaveLabel.show()
	$ProgressBar.show()
	
	emit_signal("start_game")
