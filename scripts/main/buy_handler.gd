extends Area2D

@export var control_to_show: Control
@onready var label = $"../Label"

var player_inside = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_inside = true
		label.visible = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_inside = false
		label.visible = false

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("OpenShop"):
		control_to_show.visible = true
