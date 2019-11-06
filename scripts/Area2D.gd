extends Area2D

signal game_over
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group('player'):
		emit_signal("game_over")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
