extends Area2D
export(String, FILE, "*.tscn") var next_world
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal game_ending

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			emit_signal("game_ending")
			get_tree().change_scene(next_world)