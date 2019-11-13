extends Control

func _input(event):
	if event.is_action_pressed("pause_menu"):
		changePauseState()

func changePauseState():
	var pause_state = not get_tree().paused
	get_tree().paused = pause_state
	visible = pause_state

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ResumeButton_pressed():
	changePauseState()

func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_QuitButton_pressed():
	changePauseState()
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
