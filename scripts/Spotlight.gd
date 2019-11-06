extends Node2D

const ANG_SPEED = 0.005

var dir = 1
	
func _process(_delta):
	$Light2D.color = Color(1, 1, 1)
	
	# Change color if player inside
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			$Light2D.color = Color(1, 0, 0)
	
	# Rotate
	if abs(self.rotation) > PI/6:
		dir *= -1
	self.rotate(dir * ANG_SPEED)