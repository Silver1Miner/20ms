extends Node2D

enum types {NORMAL,XBOMB,YBOMB,ABOMB}
@export var color = 0
@export var piece_type = 0
var is_matched = false
var color_sprites = [
	preload("res://assets/pieces/mmstroke_blue.png"),
	preload("res://assets/pieces/mmstroke_green.png"),
	preload("res://assets/pieces/mmstroke_purple.png"),
	preload("res://assets/pieces/mmstroke_red.png"),
	preload("res://assets/pieces/mmstroke_yellow.png")
]
var bomb_sprites = [
	preload("res://assets/pieces/bombs/swirlstroke_blue.png"),
	preload("res://assets/pieces/bombs/swirlstroke_green.png"),
	preload("res://assets/pieces/bombs/swirlstroke_purple.png"),
	preload("res://assets/pieces/bombs/swirlstroke_red.png"),
	preload("res://assets/pieces/bombs/swirlstroke_yellow.png"),
]

func set_color(new_id: int) -> void:
	if new_id < 0 or new_id > color_sprites.size():
		push_error("invalid id")
		return
	color = new_id
	$Sprite2D.texture = color_sprites[color]

func move(new_position: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", new_position, 0.3).set_trans(Tween.TRANS_ELASTIC)

func matched() -> void:
	is_matched = true
	$Sprite2D.modulate = Color(1,1,1,0.5)

func set_bomb_color(new_id: int) -> void:
	if new_id < 0 or new_id > color_sprites.size():
		push_error("invalid id")
		return
	color = new_id
	$Sprite2D.texture = bomb_sprites[color]

func change_type(new_type: int) -> void:
	piece_type = new_type
	match piece_type:
		types.NORMAL:
			set_color(color)
		types.XBOMB:
			set_bomb_color(color)
		types.YBOMB:
			set_bomb_color(color)
		types.ABOMB:
			set_bomb_color(color)
	is_matched = false
	$Sprite2D.modulate = Color(1,1,1,1)
