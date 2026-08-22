extends Node

@onready var hand = $"../Player/Hand"
@onready var pickup_area = $"../Player/PickupArea"

var equippedItem = null
var nearbyItem = null
var hover_time = 0.0

const HOVER_HEIGHT = 3.0
const HOVER_SPEED = 3.0
const ITEM_TILT = 5.0

func _ready():
	pickup_area.area_entered.connect(_on_pickup_area_entered)
	pickup_area.area_exited.connect(_on_pickup_area_exited)

func _process(delta):
	if equippedItem:
		hover_time += delta * HOVER_SPEED
		
		equippedItem.global_position = hand.global_position + Vector2(
			0,
			sin(hover_time) * HOVER_HEIGHT
		)
		
		equippedItem.rotation = deg_to_rad(ITEM_TILT)

	if Input.is_action_just_pressed("Pickup"):
		pickup()

	if Input.is_action_just_pressed("Drop"):
		drop()

	if Input.is_action_just_pressed("Plant"):
		plant()

func _on_pickup_area_entered(area):
	if area.is_in_group("Plant"):
		nearbyItem = area.get_parent()
	elif area.is_in_group("Pickup"):
		nearbyItem = area

func _on_pickup_area_exited(area):
	if area.is_in_group("Plant"):
		if area.get_parent() == nearbyItem:
			nearbyItem = null

	elif area.is_in_group("Pickup"):
		if area == nearbyItem:
			nearbyItem = null

func pickup():
	if equippedItem:
		return

	var areas = pickup_area.get_overlapping_areas()

	for area in areas:
		if area.is_in_group("Plant"):
			var plant = area.get_parent()

			if plant.has_method("harvest"):
				var pickup_item = plant.harvest()

				if pickup_item:
					equippedItem = pickup_item
					nearbyItem = null
					hover_time = 0.0

				return

		if area.is_in_group("Pickup"):
			equippedItem = area
			nearbyItem = null
			hover_time = 0.0
			return

func drop():
	if not equippedItem:
		return

	var item = equippedItem

	equippedItem = null
	nearbyItem = null

	item.global_position = hand.global_position
	item.rotation = 0

func plant():
	if not equippedItem:
		return

	if not "plant_scene" in equippedItem:
		return

	if equippedItem.plant_scene == null:
		return

	var plant_scene = equippedItem.plant_scene
	var plant_position = equippedItem.global_position

	equippedItem.queue_free()
	equippedItem = null

	var new_plant = plant_scene.instantiate()
	get_tree().current_scene.add_child(new_plant)
	new_plant.global_position = plant_position
