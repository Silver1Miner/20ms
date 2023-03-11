extends Area2D

@export var direction = Vector2.UP
@export var speed = 100
@export var player_id = 1
@export var color = 0
var color_sprites = [
	preload("res://assets/pieces/mmstroke_blue.png"),
	preload("res://assets/pieces/mmstroke_green.png"),
	preload("res://assets/pieces/mmstroke_purple.png"),
	preload("res://assets/pieces/mmstroke_red.png"),
	preload("res://assets/pieces/mmstroke_yellow.png")
]

func _ready():
	add_to_group("attack")

func _physics_process(delta):
	global_position += direction * speed * delta

func set_color(new_id: int) -> void:
	if new_id < 0 or new_id > color_sprites.size():
		push_error("invalid id")
		return
	color = new_id
	$Sprite2D.texture = color_sprites[color]
