extends CharacterBody2D

@onready var Sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const NORMAL_SCALE = Vector2.ONE
const SQUISH_SCALE = Vector2(1.15, 0.85)
const STRETCH_SCALE = Vector2(0.9, 1.1)

const SCALE_SPEED = 12.0
const ROTATION_SPEED = 8.0
const LEAN_ANGLE = 8.0

const STEP_TIME = 0.12

var step_timer := 0.0
var squish := false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("Left", "Right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x == 0:
		Sprite.play("Idle")
	else:
		Sprite.play("Walk")

	if velocity.x > 0:
		Sprite.flip_h = false

	if velocity.x < 0:
		Sprite.flip_h = true

	if velocity.x != 0:
		step_timer -= delta

		if step_timer <= 0:
			step_timer = STEP_TIME
			squish = !squish

		var target_scale = SQUISH_SCALE if squish else STRETCH_SCALE
		Sprite.scale = Sprite.scale.lerp(target_scale, SCALE_SPEED * delta)

		var target_rotation = deg_to_rad(-LEAN_ANGLE) if velocity.x > 0 else deg_to_rad(LEAN_ANGLE)
		Sprite.rotation = lerp_angle(Sprite.rotation, target_rotation, ROTATION_SPEED * delta)

	else:
		step_timer = 0
		squish = false

		Sprite.scale = Sprite.scale.lerp(NORMAL_SCALE, SCALE_SPEED * delta)
		Sprite.rotation = lerp_angle(Sprite.rotation, 0.0, ROTATION_SPEED * delta)

	move_and_slide()
