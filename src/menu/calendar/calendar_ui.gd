extends Control

signal date_selected()
const BUTTON_COUNT = 42
@onready var button_container = $Panel/Display/GridDays
@onready var month_year_label = $Panel/Display/MonthYear/LabelMonthYear

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
