extends Node2D

@export var width := 7
@export var height := 5
var board_grid_state = []
var piece_types = [
	preload("res://src/game/piece.tscn"),
	preload("res://src/game/piece.tscn"),
]

func _ready():
	initialize_board_grid()

func _process(_delta):
	pass

func initialize_board_grid() -> void:
	board_grid_state.clear()
	for i in width:
		board_grid_state.append([])
		for j in height:
			var piece_instance = piece_types[0].instantiate()
			add_child(piece_instance)
			piece_instance.position.x = i * 40
			piece_instance.position.y = j * 40
			board_grid_state[i].append(piece_instance)
	print(board_grid_state)
