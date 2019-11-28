extends RigidBody2D

const SPEED = 1000
const OFFSET = 15

var shooter


func _ready():
	$Timer.connect("timeout", self, "_on_timer_timeout")

func setup(shooter, pos, facing_right):
	self.shooter = shooter
	position = pos
	var direction = 1 if facing_right else -1
	position.x += direction * OFFSET
	var motion = Vector2()
	motion.x = direction * SPEED
	set_linear_velocity(motion)

func _on_timer_timeout():
	queue_free()

func _on_RigidBody2D_body_entered(body):
	if shooter != null:
		var shooter_name = "null" if shooter == null else shooter.name
		var body_name = body.name
		if body_name == shooter_name:
			return
		if body_name.substr(0,3) == "Mob":
			body.take_damage(25)
			queue_free()
		elif body_name == "Player":
			body.take_damage(10)
			queue_free()

func get_class(): return "Bullet"
