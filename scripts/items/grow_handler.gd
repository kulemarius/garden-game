extends Node2D

@export var grow_time := 5.0
@export var time_to_die := 15.0
@export var pickup_scene: PackedScene

@onready var sprite = $AnimatedSprite2D
@onready var grow_timer = $GrowTimer
@onready var death_timer = $DeathTimer

var current_stage := 1
var can_harvest := false
var dying := false
var dead := false

func _ready():
	grow_timer.one_shot = true
	death_timer.one_shot = true

	grow_timer.timeout.connect(_on_grow_timer_timeout)
	death_timer.timeout.connect(_on_death_timer_timeout)

	sprite.play("Stage1")
	grow_timer.start(grow_time)

func _on_grow_timer_timeout():
	if dying or dead:
		return

	current_stage += 1

	var next_animation = "Stage" + str(current_stage)

	if sprite.sprite_frames.has_animation(next_animation):
		sprite.play(next_animation)
		grow_timer.start(grow_time)
	else:
		sprite.play("FinalStage")
		can_harvest = true
		death_timer.start(time_to_die)

func _on_death_timer_timeout():
	if not can_harvest:
		return

	can_harvest = false
	dying = true

	sprite.play("Dying")
	sprite.animation_finished.connect(_on_dying_finished, CONNECT_ONE_SHOT)

func _on_dying_finished():
	dying = false
	dead = true
	sprite.play("Dead")

func harvest():
	if not can_harvest:
		return null

	if pickup_scene == null:
		return null

	var pickup = pickup_scene.instantiate()
	get_tree().current_scene.add_child(pickup)
	pickup.global_position = global_position

	queue_free()

	return pickup
