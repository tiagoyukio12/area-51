extends KinematicBody2D

const MOVE_SPEED = 250
const RUN_SPEED = 500
const ACCEL = 50
const JUMP_FORCE = 1000
const GRAVITY = 50
const MAX_FALL_SPEED = 1000


var facing_right = true
var motion = Vector2()
var max_speed = MOVE_SPEED
var life

signal life_changed

func _ready():
	life = 100
	emit_signal("life_changed", life)

func _physics_process(delta):
	motion.y += GRAVITY
	var friction = false
	
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
	
	motion = move_and_slide(motion, Vector2(0, -1))
	
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
		$AnimatedSprite.play("naruto_running")

func flip():
	facing_right = !facing_right
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	
func dead():
	
	motion = Vector2(0,0)
	
