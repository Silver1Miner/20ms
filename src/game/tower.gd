extends Area2D

signal tower_hp_updated(tower_hp)
signal tower_destroyed()
@export var player_id: int = 1
@export var tower_order: int = 0 # 0 Left 1 Center 2 Right
@export var tower_id: int = 0
@export var tower_hp: int = 20
@export var tower_weakness: int = 0

func _on_area_entered(area) -> void:
	if area.is_in_group("attack") and area.player_id != player_id:
		if tower_hp > 0:
			take_damage(area.color)
		area.queue_free()

func take_damage(color_type: int) -> void:
	if color_type == tower_weakness:
		tower_hp = int(clamp(tower_hp - 2, 0, 100))
	else:
		tower_hp = int(clamp(tower_hp - 1, 0, 100))
	emit_signal("tower_hp_updated", tower_hp)
	if tower_hp <= 0:
		show_destroyed()

func show_destroyed() -> void:
	$Sprite2D.modulate = Color(1,1,1,0.5)
	emit_signal("tower_destroyed")
