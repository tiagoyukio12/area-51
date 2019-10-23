extends KinematicBody2D

const MOVE_SPEED = 50
const GRAVITY = 50

var velocity = Vector2.ZERO
var is_walking_right = false

func _physics_process(_delta):
	# Walk
	velocity.x = MOVE_SPEED if is_walking_right else - MOVE_SPEED
	
	# Gravity
	velocity.y += GRAVITY
	if is_on_floor() and velocity.y >= 0:
		velocity.y = 5
	if velocity.y > 1000:
		velocity.y = 1000
	
	# Change color to red and stop if player in LoS
	var collision = $RayCast2D.get_collider()
	if collision and collision.name == "Player":
			velocity.x = 0
			$AnimationPlayer.stop()
			$Sprite.modulate = Color(255, 0, 0)
	else:
		$AnimationPlayer.play("walk")
		$Sprite.modulate = Color(1, 1, 1)
	
	# Move mob
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	# Draw LoS cone
	var collision_distance = 100 if velocity.x > 0 else -100
	if collision:
			var world_point = $RayCast2D.get_collision_point()
			collision_distance = world_point.x - self.position.x
	$Polygon2D.polygon[1] = Vector2(collision_distance, 10)
	$Polygon2D.polygon[2] = Vector2(collision_distance, -10)
	
	# Turn direction if collide with wall or on edge
	if is_on_wall() or !$RayCast2D2.is_colliding():
		is_walking_right = !is_walking_right
		get_node("Sprite").set_flip_h(is_walking_right)
		$RayCast2D.cast_to.x *= -1
		$RayCast2D2.position.x *= -1