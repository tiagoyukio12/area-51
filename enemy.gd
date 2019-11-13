extends KinematicBody2D


export (int) var detect_radius
export (int) var fire_rate
export (PackedScene) var Bullet
var vis_color = Color(.867, .91, .247, 0.1)

var target
var can_shoot = true

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var direction = 1

var pause = false
var first_move = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _physics_process(delta):
	velocity.y += GRAVITY	
	
	if pause == false:
		velocity.x = SPEED*direction
		velocity = move_and_slide(velocity, FLOOR)
		if direction == 1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
			first_move = false
		
		$AnimatedSprite.play("walk")
		
		if is_on_wall():
			direction = direction*-1
			$RayCast2D.position.x *= -1
			pause = true
	
		if $RayCast2D.is_colliding() == false:
			direction = direction*-1
			$RayCast2D.position.x *= -1
			if first_move == false:
				pause = true
				
		if $RayCast2D.is_colliding():
			if $RayCast2D.get_collider():
				var player = get_parent().get_parent().get_node("Player/PlayerBody")
				player.dead()
			
	else:
		$AnimatedSprite.play("idle")
		yield(get_tree().create_timer(2),"timeout")
		pause = false