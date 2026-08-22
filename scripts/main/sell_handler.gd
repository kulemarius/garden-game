extends Area2D

@onready var hold_system = $"../../ItemHandler"

func _process(_delta):
	if Input.is_action_just_pressed("Sell"):
		sell()

func sell():
	if hold_system.equippedItem == null:
		return

	var item = hold_system.equippedItem

	if not "minWorth" in item or not "maxWorth" in item:
		print("This item can't be sold!")
		return

	var worth = randi_range(item.minWorth, item.maxWorth)

	print("Sold item for $", worth)

	item.queue_free()
	hold_system.equippedItem = null
	hold_system.nearbyItem = null
