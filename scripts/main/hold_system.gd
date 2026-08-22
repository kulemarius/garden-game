extends Node

@onready var player = $"../Player"
@onready var hand = $"../Player/Hand"
@onready var pickup_area = $"../Player/PickupArea"

var equippedItem = null
var canDrop = true
var nearbyItem = null

func _ready():
	pickup_area.area_entered.connect(_on_pickup_area_entered)
	pickup_area.area_exited.connect(_on_pickup_area_exited)

func _process(delta):
	if equippedItem:
		equippedItem.global_position = hand.global_position

	if Input.is_action_just_pressed("Pickup"):
		pickup()

	if Input.is_action_just_pressed("Drop"):
		drop()

	if Input.is_action_just_pressed("Plant"):
		plant()

func _on_pickup_area_entered(area):
	if area.is_in_group("Plant"):
		nearbyItem = area
		return

	if area.is_in_group("Pickup"):
		nearbyItem = area

func _on_pickup_area_exited(area):
	if area == nearbyItem:
		nearbyItem = null

func pickup():
	if equippedItem:
		return

	if not nearbyItem:
		return

	if nearbyItem.is_in_group("Plant"):
		var pickup = nearbyItem.harvest()

		if pickup:
			equippedItem = pickup

		return

	if nearbyItem.is_in_group("Pickup"):
		equippedItem = nearbyItem

func drop():
	if not equippedItem or not canDrop:
		return

	equippedItem.global_position = hand.global_position
	equippedItem = null

func plant():
	if not equippedItem:
		return

	if not "plant_scene" in equippedItem:
		return

	if equippedItem.plant_scene == null:
		return

	var plant_position = equippedItem.global_position
	var plant_scene = equippedItem.plant_scene

	equippedItem.queue_free()
	equippedItem = null

	var plant = plant_scene.instantiate()
	get_tree().current_scene.add_child(plant)
	plant.global_position = plant_position
