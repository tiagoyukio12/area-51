extends Node2D

const MOB = preload("../scenes/Mob.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob = MOB.instance()
	add_child(mob)
	mob.position = Vector2(900, 500)