extends Node2D

@export var color = 0
var is_matched = false
var color_sprites = [
	preload("res://assets/pieces/mmstroke_blue.png"),
	preload("res://assets/pieces/mmstroke_green.png"),
	preload("res://assets/pieces/mmstroke_purple.png"),
	preload("res://assets/pieces/mmstroke_red.png"),
	preload("res://assets/pieces/mmstroke_yellow.png")
]

func set_color(new_id: int) -> void:
	if new_id < 0 or new_id > color_sprites.size():
		push_error("invalid id")
		return
	color = new_id
	$Sprite2D.texture = color_sprites[color]

func move(new_position: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", new_position, 0.3).set_trans(Tween.TRANS_SINE)

func matched() -> void:
	is_matched = true
	$Sprite2D.modulate = Color(1,1,1,0.5)
