extends Button

@export var price = 0
@export var Prefab: PackedScene

@onready var stats = $"../../../../../StatsHandler"
@onready var seedSpawner = $"../../../../../SeedSpawer"

func _on_pressed() -> void:
	if stats.CurrentMoney >= price:
		stats.CurrentMoney -= price

		var seed = Prefab.instantiate()
		seedSpawner.add_child(seed)
		seed.position = Vector2.ZERO
