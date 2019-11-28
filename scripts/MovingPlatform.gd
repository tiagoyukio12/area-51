extends RigidBody2D

export var left_limit = -100
export var right_limit = 100
export var up_limit = 0
export var down_limit = 0
export var wait_player = false

const SPEED = 100

var is_moving_right = true
var is_moving_up = true
var pos_initial
var player_is_on_top = false

func _ready():
	pos_initial = position

func _process(delta):
	if self.position.x > pos_initial.x + right_limit:
		is_moving_right = false
	elif self.position.x < pos_initial.x + left_limit:
		is_moving_right = true
	
	var direction = 1 if is_moving_right else -1
	if right_limit - left_limit <= 0:
		direction = 0
	var motion = Vector2()
	motion.x = direction * SPEED
	
	if self.position.y > pos_initial.y + up_limit:
		is_moving_up = false
	elif self.position.y < pos_initial.y + down_limit:
		is_moving_up = true
	
	direction = 1 if is_moving_up else -1
	if up_limit - down_limit <= 0:
		direction = 0
	motion.y = direction * SPEED
	
	if not wait_player or player_is_on_top:
		set_linear_velocity(motion)
	else:
		set_linear_velocity(Vector2(0, 0))

func _on_MovingPlatform_body_entered(body):
	print(body.name)
	if body.name == "Player":
		player_is_on_top = true
