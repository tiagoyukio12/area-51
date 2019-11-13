extends Control

func _input(event):
	if event.is_action_pressed("pause_menu"):
		changePauseState()

func changePauseState():
	var pause_state = not get_tree().paused
	print(pause_state)
	get_tree().paused = pause_state
	visible = pause_state

func _on_ResumeButton_pressed():
	changePauseState()

func _on_OptionsButton_pressed():
	pass # Replace with function body.

func _on_QuitButton_pressed():
	changePauseState()
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
