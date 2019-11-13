extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# onready var number_label = $Bars/LifeBar/Count/Background/Number
onready var bar = $Bars/LifeBar/Gauge
onready var tween = $Tween

var animated_health = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_max_health = $"../../Player".max_health
	bar.max_value = player_max_health
	update_health(player_max_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
# 	number_label.text = str(animated_health)
	bar.value = animated_health

func _on_Player_health_changed(health):
	update_health(health)
	
func update_health(new_value):
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()
