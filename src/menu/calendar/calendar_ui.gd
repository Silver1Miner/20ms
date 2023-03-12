extends Control

signal date_selected(date)
const BUTTON_COUNT = 42
var calendar := Calendar.new()
var date := Date.new()
@onready var button_container = $Panel/Display/GridDays
@onready var month_year_label = $Panel/Display/MonthYear/LabelMonthYear
@onready var month_year_panel = $Panel/Display/MonthYear

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_button_signals()
	refresh_data()
	check_today()

func setup_button_signals() -> void:
	for i in range(BUTTON_COUNT):
		var btn_node = button_container.get_node("Button"+str(i))
		btn_node.connect("pressed", Callable(self, "on_day_selected").bind(btn_node))

func check_today() -> void:
	var days_in_month : int = calendar.get_days_in_month(date.get_month(), date.get_year())
	var start_day_of_week : int = calendar.get_weekday(1, date.get_month(), date.get_year())
	for i in range(days_in_month):
		var btn_node : Button = button_container.get_node("Button" + str(i + start_day_of_week))
		if(i + 1 == calendar.get_day() && date.get_year() == calendar.get_year() && date.get_month() == calendar.get_month() ):
			btn_node.emit_signal("pressed")

func on_day_selected(button: Button) -> void:
	var day := int(button.get_text())
	date.set_day(day)
	update_calendar_buttons(date)
	print(date.get_year(), "-", date.get_month(), "-", date.get_day())
	emit_signal("date_selected", date)

func update_calendar_buttons(selected_date: Date) -> void:
	_clear_calendar_buttons()
	var days_in_month : int = calendar.get_days_in_month(selected_date.get_month(), selected_date.get_year())
	var start_day_of_week : int = calendar.get_weekday(1, selected_date.get_month(), selected_date.get_year())
	for i in range(days_in_month):
		var btn_node : Button = button_container.get_node("Button" + str(i + start_day_of_week))
		btn_node.set_text(str(i + 1))
		#if str(i+1) in UserData.current_loaded:
		#	btn_node.set_disabled(false)
		#else:
		btn_node.set_disabled(false)

func _clear_calendar_buttons():
	for i in range(BUTTON_COUNT):
		var btn_node : Button = button_container.get_node("Button" + str(i))
		btn_node.set_text("")
		btn_node.set_disabled(true)

func refresh_data():
	var title : String = str(calendar.get_month_name(date.get_month()) + " " + str(date.get_year()))
	month_year_label.set_text(title)
	update_calendar_buttons(date)

func _on_button_prev_month_pressed():
	date.change_to_prev_month()
	refresh_data()

func _on_button_prev_year_pressed():
	date.change_to_prev_year()
	refresh_data()

func _on_button_next_year_pressed():
	date.change_to_next_year()
	refresh_data()

func _on_button_next_month_pressed():
	date.change_to_next_month()
	refresh_data()
