extends Area2D

@export var width := 7
@export var height := 5
@export var color_number := 4
@export var tile_size := 40
@export var y_grid_spawn_offset := 2
@export var player_id := 1
@onready var collapse_timer = $CollapseTimer
@onready var refill_timer = $RefillTimer
@onready var remove_timer = $RemoveTimer
@onready var ready_timer = $ReadyTimer
@onready var ready_sound = $AudioStreamPlayer
var grid_state = []
var current_matches = []
var piece = preload("res://src/game/piece.tscn")
var draw_start = Vector2.ZERO
var draw_end = Vector2.ZERO
var cell_start = Vector2.ZERO
var cell_end = Vector2.ZERO
var last_move = Vector2.ZERO
var last_move_direction = Vector2.ZERO
enum States {IDLE,READY,MOVING}
var state = States.READY

func _ready():
	initialize_board_grid()

func _on_input_event(_viewport, event, _shape_idx):
	if state == States.READY:
		if event is InputEventScreenTouch:
			if event.is_pressed():
				draw_start = event.position - global_position
				cell_start = pixel_to_grid(draw_start)
				print("player ", player_id, " start touch at ", cell_start)
				state = States.MOVING
	elif state == States.MOVING:
		if event is InputEventScreenTouch:
			if not event.is_pressed():
				draw_end = event.position - global_position
				cell_end = pixel_to_grid(draw_end)
				print("player ", player_id, " end touch at ", cell_end)
				touch_difference(cell_start, cell_end)
		if event is InputEventScreenDrag:
			draw_end = event.position - global_position
			cell_end = pixel_to_grid(draw_end)
			if not is_within_limits(cell_end):
				print("left area")
				draw_start = Vector2.ZERO
				draw_end = Vector2.ZERO
				state = States.READY

func _on_mouse_exited():
	print("left area")
	draw_start = Vector2.ZERO
	draw_end = Vector2.ZERO
	state = States.READY

func is_within_limits(cell: Vector2) -> bool:
	var out := cell.x >= 0 and cell.x < width
	return out and cell.y >= 0 and cell.y < height

func grid_to_pixel(cell: Vector2) -> Vector2:
	return cell * tile_size

func pixel_to_grid(pos: Vector2) -> Vector2:
	var x = floor(pos.x/tile_size)
	var y = floor(pos.y/tile_size)
	return Vector2(x, y)

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
			while is_match_at(i, j, piece_instance.color) > 0 and failsafe < 100:
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

func is_match_at(i: int, j: int, color: int) -> int:
	var match_type = 0 # 0 none 1 horizontal 2 vertical 3 both
	if i > 1:
		if grid_state[i-1][j] != null and grid_state[i-2][j] != null:
			if grid_state[i-1][j].color == color and grid_state[i-2][j].color == color:
				match_type += 1
	if j > 1:
		if grid_state[i][j-1] != null and grid_state[i][j-2] != null:
			if grid_state[i][j-1].color == color and grid_state[i][j-2].color == color:
				match_type += 2
	return match_type

func swap_at(i, j, direction: Vector2) -> void:
	var start_piece = grid_state[i][j]
	if start_piece == null:
		return
	var end_piece = grid_state[i+direction.x][j+direction.y]
	grid_state[i][j] = end_piece
	grid_state[i+direction.x][j+direction.y] = start_piece
	start_piece.move(grid_to_pixel(Vector2(i+direction.x,j+direction.y)))
	if end_piece:
		end_piece.move(grid_to_pixel(Vector2(i,j)))
	last_move = Vector2(i+direction.x, j+direction.y)
	last_move_direction = direction
	find_all_matches()

func touch_difference(start: Vector2, end: Vector2) -> void:
	var diff = end - start
	if abs(diff.x) > abs(diff.y):
		if diff.x > 0:
			swap_at(start.x, start.y, Vector2.RIGHT)
		elif diff.x < 0:
			swap_at(start.x, start.y, Vector2.LEFT)
	elif abs(diff.y) > abs(diff.x):
		if diff.y > 0:
			swap_at(start.x, start.y, Vector2.DOWN)
		elif diff.y < 0:
			swap_at(start.x, start.y, Vector2.UP)

func find_all_matches() -> void:
	var has_match = false
	for i in width:
		for j in height:
			if grid_state[i][j] != null:
				var match_code = is_match_at(i, j, grid_state[i][j].color)
				if match_code == 1 or match_code == 3:
					grid_state[i][j].matched()
					grid_state[i-1][j].matched()
					grid_state[i-2][j].matched()
					record_matched(Vector2(i,j))
					record_matched(Vector2(i-1,j))
					record_matched(Vector2(i-2,j))
					has_match = true
				if match_code == 2 or match_code == 3:
					grid_state[i][j].matched()
					grid_state[i][j-1].matched()
					grid_state[i][j-2].matched()
					record_matched(Vector2(i,j))
					record_matched(Vector2(i,j-1))
					record_matched(Vector2(i,j-2))
					has_match = true
	if has_match:
		remove_timer.start()
	else:
		ready_timer.start()

func record_matched(cell: Vector2) -> void:
	if not cell in current_matches:
		current_matches.append(cell)

func find_powerups() -> void:
	for i in current_matches.size():
		var curr_x = current_matches[i].x
		var curr_y = current_matches[i].y
		var curr_color = grid_state[curr_x][curr_y].color
		var col_matched = 0
		var row_matched = 0
		for j in current_matches.size():
			var this_x = current_matches[j].x
			var this_y = current_matches[j].y
			var this_color = grid_state[this_x][this_y].color
			if this_x == curr_x and this_color == curr_color:
				col_matched += 1
			if this_y == curr_y and this_color == curr_color:
				row_matched += 1
		if col_matched == 4:
			print("col match 4")
		if row_matched == 4:
			print("row match 4")
		if col_matched == 3 and row_matched == 3:
			print("overlap match 5")
		if col_matched == 5 or row_matched == 5:
			print("series match 5")

func remove_matches() -> void:
	find_powerups()
	for i in width:
		for j in height:
			if grid_state[i][j] and grid_state[i][j].is_matched:
				grid_state[i][j].queue_free()
				grid_state[i][j] = null
	current_matches.clear()
	collapse_timer.start()

func collapse_columns() -> void:
	if player_id == 1: # collapse up/-Y
		for i in width:
			for j in height:
				if grid_state[i][j] == null:
					for k in range(j+1, height):
						if grid_state[i][k] != null:
							grid_state[i][k].move(grid_to_pixel(Vector2(i, j)))
							grid_state[i][j] = grid_state[i][k]
							grid_state[i][k] = null
							break
	elif player_id == 2: # collapse down/+Y
		for i in width:
			for j in range(height-1,-1,-1):
				if grid_state[i][j] == null:
					for k in range(j-1, -1,-1):
						if grid_state[i][k] != null:
							grid_state[i][k].move(grid_to_pixel(Vector2(i, j)))
							grid_state[i][j] = grid_state[i][k]
							grid_state[i][k] = null
							break
	refill_timer.start()

func refill_columns() -> void:
	for i in width:
		for j in height:
			if grid_state[i][j] == null:
				randomize()
				var rand = floor(randi_range(0, color_number))
				var piece_instance = piece.instantiate()
				piece_instance.set_color(rand)
				var failsafe = 0
				while is_match_at(i, j, piece_instance.color) > 0 and failsafe < 100:
					rand = floor(randi_range(0, color_number))
					piece_instance.set_color(rand)
					failsafe += 1
				if failsafe >= 100:
					print("random failed")
				add_child(piece_instance)
				piece_instance.position.x = i * tile_size
				if player_id == 1:
					piece_instance.position.y = (j + y_grid_spawn_offset) * tile_size
				elif player_id == 2:
					piece_instance.position.y = (j - y_grid_spawn_offset) * tile_size
				piece_instance.move(grid_to_pixel(Vector2(i, j)))
				grid_state[i][j] = piece_instance
	find_all_matches()

func _on_remove_timer_timeout():
	remove_matches()

func _on_collapse_timer_timeout():
	collapse_columns()

func _on_refill_timer_timeout():
	refill_columns()

func _on_ready_timer_timeout():
	ready_sound.play()
	state = States.READY
