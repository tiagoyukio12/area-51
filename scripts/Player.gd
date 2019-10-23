extends KinematicBody2D

const MOVE_SPEED = 250
const RUN_SPEED = 500
const ACCEL = 50
const JUMP_FORCE = 1000
const GRAVITY = 50
const MAX_FALL_SPEED = 1000

onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

var facing_right = false
var motion = Vector2()
var max_speed = MOVE_SPEED

func _physics_process(_delta):
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
			play_anim("idle")
		else:
			play_anim("walk")
	else:
		play_anim("jump")

func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)