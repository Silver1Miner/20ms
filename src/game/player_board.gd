extends Node2D

signal player_defeated()
@export var player_id = 1
var towers = [1,1,1]
@onready var board_grid = $BoardGrid
@onready var tower_left = $TowerLeft
@onready var tower_center = $TowerCenter
@onready var tower_right = $TowerRight
@onready var bar_left = $PlayerStatus/LeftBar
@onready var bar_center = $PlayerStatus/CenterBar
@onready var bar_right = $PlayerStatus/RightBar

# Called when the node enters the scene tree for the first time.
func _ready():
	board_grid.player_id = player_id
	tower_left.player_id = player_id
	tower_center.player_id = player_id
	tower_right.player_id = player_id
	_on_tower_left_tower_hp_updated(tower_left.tower_hp)
	_on_tower_center_tower_hp_updated(tower_center.tower_hp)
	_on_tower_right_tower_hp_updated(tower_right.tower_hp)

func _on_tower_left_tower_hp_updated(tower_hp: int):
	bar_left.value = tower_hp

func _on_tower_center_tower_hp_updated(tower_hp: int):
	bar_center.value = tower_hp

func _on_tower_right_tower_hp_updated(tower_hp: int):
	bar_right.value = tower_hp

func _on_tower_left_tower_destroyed():
	towers[0] = 0
	check_towers()

func _on_tower_center_tower_destroyed():
	towers[1] = 0
	check_towers()

func _on_tower_right_tower_destroyed():
	towers[2] = 0
	check_towers()

func check_towers():
	if towers[0] + towers[1] + towers[2] == 0:
		emit_signal("player_defeated")
