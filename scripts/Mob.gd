extends KinematicBody2D

const MOVE_SPEED = 50
const GRAVITY = 50

var velocity = Vector2.ZERO
var is_walking_right = false


func _physics_process(_delta):
	# Follow player if in view
	velocity.x = MOVE_SPEED if is_walking_right else - MOVE_SPEED
	var collision = $RayCast2D.get_collider()
	if collision and collision.name == "Player":
			velocity.x = 0
			$AnimationPlayer.stop()
			$Sprite.modulate = Color(255, 0, 0)
	else:
		$AnimationPlayer.play("walk")
		$Sprite.modulate = Color(1, 1, 1)
	
	# Gravity
	var grounded = is_on_floor()
	velocity.y += GRAVITY
	if grounded and velocity.y >= 0:
		velocity.y = 5
	if velocity.y > 1000:
		velocity.y = 1000
	
	velocity = move_and_slide(velocity)
	
	if abs(velocity.x) < 0.1 and !(collision.name == "Player"):
		is_walking_right = !is_walking_right
		get_node("Sprite").set_flip_h(is_walking_right)
		$RayCast2D.cast_to.x *= -1