extends Node

@onready var timer = $DayTimer
@onready var label = $Canvas/UI/TimeleftLabel
@onready var sprite = $Canvas/UI/Clock_Fill

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _process(_delta):
	label.text = "%.2f" % timer.time_left
	
	var progress = 1.0 - (timer.time_left / 119.99)
	sprite.rotation = deg_to_rad(180.0 * progress)

func _on_timer_timeout():
	get_tree().reload_current_scene()
