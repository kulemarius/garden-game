extends Node

@export var day_color: Color = Color.WHITE
@export var night_color: Color = Color(0.05, 0.05, 0.1)

@onready var timer = $DayTimer
@onready var label = $Canvas/UI/TimeleftLabel
@onready var sprite = $Canvas/UI/Clock_Fill
@onready var color_rect = $Background
@onready var stars = $StarsTilemap

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _process(_delta):
	label.text = "%.2f" % timer.time_left
	
	var progress = 1.0 - (timer.time_left / 119.99)
	
	sprite.rotation = deg_to_rad(180.0 * progress)
	
	color_rect.color = day_color.lerp(night_color, progress)
	
	var star_progress = clamp((progress - 0.3) / 0.7, 0.0, 1.0)
	stars.modulate.a = star_progress

func _on_timer_timeout():
	get_tree().reload_current_scene()
