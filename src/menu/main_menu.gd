extends Control

@onready var panes = get_node("Panes")
@onready var select_bar = get_node("SelectBar")
var swipe_start = Vector2.ZERO
var minimum_drag = 100

func _ready():
	if select_bar.connect("selected", Callable(self, "_on_select_bar_selected")) != OK:
		push_error("fail to connect select bar signal")

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start = event.get_position()
		else:
			if swipe_start == Vector2.ZERO:
				return
			var swipe = event.get_position() - swipe_start
			if abs(swipe.x) < minimum_drag:
				return
			var choice = 2
			if swipe.x < 0:
				choice = select_bar.current_select + 1
			else:
				choice = select_bar.current_select - 1
			if choice >= 0 and choice < 5:
				select_bar.get_children()[choice].button_pressed = true

func _on_select_bar_selected(current_select: int) -> void:
	if current_select < 0 or current_select > 4:
		return
	var tween = create_tween()
	tween.tween_property(
		panes, "position:x",
		(current_select) * -360, 0.2
	)
