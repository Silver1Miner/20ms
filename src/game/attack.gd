extends Area2D

@export var direction = Vector2.UP
@export var speed = 100
@export var player_id = 1

func _ready():
	add_to_group("attack")

func _physics_process(delta):
	global_position += direction * speed * delta
