extends RichTextLabel

@onready var money = $"../../../StatsHandler"

var last_money = 0
var animating = false

func _ready():
	last_money = money.CurrentMoney
	bbcode_enabled = true
	update_text()

func _process(_delta):
	if money.CurrentMoney != last_money:
		animate_money()
		last_money = money.CurrentMoney

	update_text()

func update_text():
	text = "[wave amp=50 freq=5]%d$[/wave]" % money.CurrentMoney

	if money.CurrentMoney >= 0:
		modulate = Color(0.459, 1.0, 0.435, 1.0)
	elif money.CurrentMoney <= -100:
		modulate = Color(1.0, 0.414, 0.371, 1.0)
	else:
		modulate = Color.WHITE

func animate_money():
	if animating:
		return

	animating = true

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)

	scale = Vector2(1.0, 1.0)

	tween.tween_property(self, "scale", Vector2(1.35, 1.35), 0.18)
	tween.tween_property(self, "scale", Vector2(0.95, 0.95), 0.12)
	tween.tween_property(self, "scale", Vector2(1.08, 1.08), 0.10)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15)

	await tween.finished
	animating = false
