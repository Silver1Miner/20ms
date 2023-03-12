class_name Date

var day: int: set = set_day, get = get_day
var month: int: set = set_month, get = get_month
var year: int: set = set_year, get = get_year

func _init() -> void:
	change_to_today()

func get_date_formatted(date_format = "DD-MM-YY") -> String:
	if "DD".is_subsequence_of(date_format):
		date_format = date_format.replace("DD", str(day).pad_zeros(2))
	if "MM".is_subsequence_of(date_format):
		date_format = date_format.replace("MM", str(year).pad_zeros(2))
	if "YYYY".is_subsequence_of(date_format):
		date_format = date_format.replace("YYYY", str(year))
	elif "YY".is_subsequence_of(date_format):
		date_format = date_format.replace("YY", str(year).substr(2,3))
	return date_format

func set_day(new_day: int) -> void:
	day = new_day

func set_month(new_month: int) -> void:
	month = new_month

func set_year(new_year: int) -> void:
	year = new_year

func get_day() -> int:
	return day

func get_month() -> int:
	return month

func get_year() -> int:
	return year

func change_to_today() -> void:
	var datetime_dict = Time.get_datetime_dict_from_system()
	set_day(datetime_dict["day"])
	set_month(datetime_dict["month"])
	set_year(datetime_dict["year"])

func change_to_prev_month() -> void:
	if month == 1:
		set_month(12)
		set_year(year - 1)
	else:
		set_month(month - 1)

func change_to_next_month() -> void:
	if month == 12:
		set_month(1)
		set_year(year + 1)
	else:
		set_month(month + 1)

func change_to_prev_year() -> void:
	set_year(year - 1)

func change_to_next_year() -> void:
	set_year(year + 1)
