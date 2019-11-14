extends RigidBody2D

const SPEED = 1000
const OFFSET = 15


func _ready():
	$Timer.connect("timeout", self, "_on_timer_timeout")

func setup(pos, facing_right):
	position = pos
	var direction = 1 if facing_right else -1
	position.x += direction * OFFSET
	var motion = Vector2()
	motion.x = direction * SPEED
	set_linear_velocity(motion)

func _on_timer_timeout():
	queue_free()

func _on_RigidBody2D_body_entered(body):
	if body.name == "Enemy":
		body.queue_free()
		queue_free()
