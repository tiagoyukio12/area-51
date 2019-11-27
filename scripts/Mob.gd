extends KinematicBody2D

const BULLET = preload("../scenes/Bullet.tscn")
const MOVE_SPEED = 50
const GRAVITY = 50

onready var health = $Node2D/HealthBar
var velocity = Vector2.ZERO
var is_walking_right = false
var sight_radius = 250


func _ready():
	$RayCast2D.cast_to = Vector2(-sight_radius, 0)

func _physics_process(_delta):
	# Walk
	velocity.x = MOVE_SPEED if is_walking_right else - MOVE_SPEED
	
	# Gravity
	velocity.y += GRAVITY
	if is_on_floor() and velocity.y >= 0:
		velocity.y = 5
	if velocity.y > 1000:
		velocity.y = 1000
	
	# Shoot and stop if player in LoS
	var collision = $RayCast2D.get_collider()
	if collision and (collision.name == "Player" or collision.get_class() == "Bullet"):
			velocity.x = 0
			$AnimatedSprite.stop()
			shoot_bullet()
	else:
		$AnimatedSprite.play("walk")
	
	# Move mob
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	# Draw LoS cone
	var collision_distance = sight_radius if velocity.x > 0 else -sight_radius
	if collision and collision.get_class() != "Bullet":
		var world_point = $RayCast2D.get_collision_point()
		collision_distance = world_point.x - self.position.x
	var polygon_height = sight_radius / 20 + 5
	$Polygon2D.polygon[1] = Vector2(collision_distance, polygon_height)
	$Polygon2D.polygon[2] = Vector2(collision_distance, -polygon_height)
	
	# Turn direction if collide with wall or on edge
	if is_on_wall() or !$RayCast2D2.is_colliding():
		is_walking_right = !is_walking_right
		get_node("AnimatedSprite").set_flip_h(is_walking_right)
		$RayCast2D.cast_to.x *= -1
		$RayCast2D2.position.x *= -1

func shoot_bullet():
	if $ShootingTimer.get_time_left() == 0:
		var bullet = BULLET.instance()
		bullet.setup(self, position, is_walking_right)
		get_parent().add_child(bullet)
		$ShootingTimer.start()

func take_damage(damage):
	health.value -= damage
	if health.value <= 0:
		queue_free()	