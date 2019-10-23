extends Area2D

export(String, FILE, "*.tscn") var next_world

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			get_tree().change_scene(next_world)
