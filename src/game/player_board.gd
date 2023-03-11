extends Node2D

@export var player_id = 1
@onready var board_grid = $BoardGrid
@onready var tower_left = $TowerLeft
@onready var tower_center = $TowerCenter
@onready var tower_right = $TowerRight

# Called when the node enters the scene tree for the first time.
func _ready():
	board_grid.player_id = player_id
	tower_left.player_id = player_id
	tower_center.player_id = player_id
	tower_right.player_id = player_id
