extends KinematicBody2D

const BULLET = preload("../scenes/Bullet.tscn")
const MOVE_SPEED = 250
const RUN_SPEED = 500
const ACCEL = 50
const JUMP_FORCE = 1000
const GRAVITY = 50
const MAX_FALL_SPEED = 1000


onready var healthbar = $Node2D/TextureProgress
var facing_right = true
var motion = Vector2()
var max_speed = MOVE_SPEED
var can_shoot = true

var max_health = 100
var health = 100

signal health_changed

func _ready():
	pass

func _physics_process(delta):
	motion.y += GRAVITY
	
	if health <= 0:
		motion.x = 0
		motion = move_and_slide(motion, Vector2.UP, false, 4, PI/4, false)
		return
	
	var friction = false
	if Input.is_action_just_pressed("shoot"):
		if can_shoot:
			var bullet = BULLET.instance()
			bullet.setup(self, position, facing_right)
			get_parent().add_child(bullet)
	if Input.is_action_pressed("move_right"):
		motion.x = min(motion.x + ACCEL, max_speed)
	elif Input.is_action_pressed("move_left"):
		motion.x = max(motion.x - ACCEL, -max_speed)
	else:
		friction = true
	if is_on_floor():
		if Input.is_action_pressed("naruto_run"):
			max_speed = RUN_SPEED
		else:
			max_speed = MOVE_SPEED
	
	motion = move_and_slide(motion, Vector2.UP, false, 4, PI/4, false)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * 100)
	
	var grounded = is_on_floor()
	if grounded:
		if friction:
			motion.x = lerp(motion.x, 0, 0.2)
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMP_FORCE
		if motion.y >= 0:
			motion.y = 5
	else:
		motion.x = lerp(motion.x, 0, 0.05)
	if motion.y > MAX_FALL_SPEED:
		motion.y = MAX_FALL_SPEED
	
	if facing_right and motion.x < 0:
		flip()
	if !facing_right and motion.x > 0:
		flip()
	
	if grounded:
		if abs(motion.x) < 10:
			$AnimatedSprite.play("idle")
		else:
			$AnimatedSprite.play("naruto_running")
	else:
		$AnimatedSprite.play("jump")

func flip():
	facing_right = !facing_right
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	
func dead():
	motion = Vector2(0,0)

func _process(delta):
	if Input.is_action_pressed("pause_menu"):
		pass

func _on_World2_ready():
	can_shoot = true
	$Camera2D.zoom = Vector2(1, 1)

func take_damage(damage):
	health -= damage
	emit_signal("health_changed")
	if health <= 0:
		$AnimatedSprite.play("dead")
		# TODO: game over
	healthbar.value = health
