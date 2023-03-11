extends Area2D

signal tower_destroyed()
@export var player_id = 1
@export var tower_order = 0 # 0 Left 1 Center 2 Right
@export var tower_id = 0
@export var tower_hp = 100

func _ready():
	pass # Replace with function body.

func _process(_delta):
	pass

func _on_area_entered(area) -> void:
	if area.is_in_group("attack") and area.player_id != player_id:
		print("attack hit")
		area.queue_free()
