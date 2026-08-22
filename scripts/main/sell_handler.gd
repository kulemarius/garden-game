extends Area2D

@onready var hold_system = $"../../ItemHandler"
@onready var money = $"../../StatsHandler"

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

	money.CurrentMoney += worth

	print("Sold item for $", worth)
	print("Current Money: $", money.CurrentMoney)

	item.queue_free()

	hold_system.equippedItem = null
	hold_system.nearbyItem = null
