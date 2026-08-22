extends Label

@onready var money = $"../../../StatsHandler"

func _process(_delta):
	text = "%d$" % money.NeededMoney
