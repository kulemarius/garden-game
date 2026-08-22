extends Camera2D

@export var zoom_speed := 0.1
@export var zoom_smoothness := 8.0
@export var min_zoom := 0.5
@export var max_zoom := 2.0

@export var mouse_follow_strength := 0.15
@export var mouse_follow_smoothness := 5.0

var target_zoom := Vector2.ONE
var target_offset := Vector2.ZERO

func _ready():
	target_zoom = zoom

func _process(delta):
	if Input.is_action_just_pressed("ZoomIn"):
		target_zoom += Vector2.ONE * zoom_speed

	if Input.is_action_just_pressed("ZoomOut"):
		target_zoom -= Vector2.ONE * zoom_speed

	target_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)
	target_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)

	zoom = zoom.lerp(target_zoom, zoom_smoothness * delta)

	var viewport_size = get_viewport_rect().size
	var mouse_position = get_viewport().get_mouse_position()

	var mouse_offset = mouse_position - viewport_size / 2.0
	target_offset = mouse_offset * mouse_follow_strength

	offset = offset.lerp(target_offset, mouse_follow_smoothness * delta)
