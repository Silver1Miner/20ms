extends TextureButton

signal selected(id)
@export var id = 0
@export var length_min = 60
@export var length_max = 120
@onready var label = $Label
@onready var symbol = $Icon
@onready var label_font_size = label.label_settings
var font_min = 12
var font_max = 24

func _on_toggled(button_press: bool) -> void:
	label.visible = button_press
	if button_press:
		var tween = create_tween()
		tween.tween_property(self, "custom_minimum_size:x", 120, 0.3)
		tween.parallel().tween_property(label_font_size, "font_size", 24, 0.3)
		tween.parallel().tween_property(symbol, "size", Vector2(80, 80), 0.3)
		tween.parallel().tween_property(symbol, "position", Vector2(20, -40), 0.3)
		emit_signal("selected", id)
		disabled = true
	else:
		var tween = create_tween()
		tween.tween_property(self, "custom_minimum_size:x", 60, 0.3)
		tween.parallel().tween_property(label_font_size, "font_size", 24, 0.3)
		tween.parallel().tween_property(symbol, "size", Vector2(60, 60), 0.3)
		tween.parallel().tween_property(symbol, "position", Vector2(0, 0), 0.3)
		disabled = false
