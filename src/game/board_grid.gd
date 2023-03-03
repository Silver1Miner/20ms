extends Node2D

@export var width := 7
@export var height := 5
@export var color_number := 4
@export var tile_size := 40
var grid_state = []
var piece = preload("res://src/game/piece.tscn")

func _ready():
	initialize_board_grid()

func _process(_delta):
	pass

func initialize_board_grid() -> void:
	grid_state.clear()
	for i in width:
		grid_state.append([])
		for j in height:
			randomize()
			var rand = floor(randi_range(0, color_number))
			var piece_instance = piece.instantiate()
			piece_instance.set_color(rand)
			var failsafe = 0
			while is_match_at(i, j, piece_instance.color) and failsafe < 100:
				rand = floor(randi_range(0, color_number))
				piece_instance.set_color(rand)
				failsafe += 1
			if failsafe >= 100:
				print("random failed")
			add_child(piece_instance)
			piece_instance.position.x = i * tile_size
			piece_instance.position.y = j * tile_size
			grid_state[i].append(piece_instance)
	print(grid_state)

func is_match_at(i: int, j: int, color: int) -> bool:
	if i > 1:
		if grid_state[i-1][j] != null and grid_state[i-2][j] != null:
			if grid_state[i-1][j].color == color and grid_state[i-2][j].color == color:
				return true
	if j > 1:
		if grid_state[i][j-1] != null and grid_state[i][j-2] != null:
			if grid_state[i][j-1].color == color and grid_state[i][j-2].color == color:
				return true
	return false
