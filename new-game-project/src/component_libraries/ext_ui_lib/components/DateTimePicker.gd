@tool
extends PanelContainer
class_name DateTimePicker
## A lightweight Date+Time picker:
## - Calendar grid (month view)
## - SpinBoxes for hour/minute
##
## Emulates the kind of picker desktop apps often need.
##
## Signals:
##   changed(datetime_dict)
## where datetime_dict = { "year":int, "month":int, "day":int, "hour":int, "minute":int }
##
## Notes:
## - Uses local time concepts; you can map this to Time.get_datetime_dict_from_unix_time() as needed.

signal changed(value: Dictionary)

@export var show_time := true
@export var start_year := 1970
@export var end_year := 2100

@export var tokens: UIStyleTokens = UIStyleTokens.new()

var _current := Time.get_datetime_dict_from_system()
var _selected := {}

var _month_label: Label
var _grid: GridContainer
var _hour: SpinBox
var _minute: SpinBox
var _year_opt: OptionButton
var _month_opt: OptionButton

func _ready() -> void:
	_selected = {
		"year": _current.year,
		"month": _current.month,
		"day": _current.day,
		"hour": _current.hour,
		"minute": _current.minute
	}
	_build()
	_refresh()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", int(tokens.space_s))
	add_child(root)

	# Header: month/year controls
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", int(tokens.space_s))
	root.add_child(header)

	var prev := Button.new()
	prev.text = "‹"
	prev.custom_minimum_size = Vector2(34, 30)
	prev.pressed.connect(func(): _add_month(-1))
	header.add_child(prev)

	_month_label = Label.new()
	_month_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_month_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_child(_month_label)

	var next := Button.new()
	next.text = "›"
	next.custom_minimum_size = Vector2(34, 30)
	next.pressed.connect(func(): _add_month(1))
	header.add_child(next)

	# Optional dropdowns for fast change
	var row2 := HBoxContainer.new()
	row2.add_theme_constant_override("separation", int(tokens.space_s))
	root.add_child(row2)

	_year_opt = OptionButton.new()
	for y in range(start_year, end_year + 1):
		_year_opt.add_item(str(y), y)
	_year_opt.item_selected.connect(func(_idx): _set_year(_year_opt.get_selected_id()))
	row2.add_child(_year_opt)

	_month_opt = OptionButton.new()
	for m in range(1, 13):
		_month_opt.add_item(_month_name(m), m)
	_month_opt.item_selected.connect(func(_idx): _set_month(_month_opt.get_selected_id()))
	row2.add_child(_month_opt)

	# Weekday labels
	var weekdays := HBoxContainer.new()
	weekdays.add_theme_constant_override("separation", 0)
	root.add_child(weekdays)
	for w in ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]:
		var l := Label.new()
		l.text = w
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.modulate.a = 0.75
		weekdays.add_child(l)

	_grid = GridContainer.new()
	_grid.columns = 7
	root.add_child(_grid)

	if show_time:
		var time_row := HBoxContainer.new()
		time_row.add_theme_constant_override("separation", int(tokens.space_s))
		root.add_child(time_row)

		var tlabel := Label.new()
		tlabel.text = "Time"
		time_row.add_child(tlabel)

		_hour = SpinBox.new()
		_hour.min_value = 0
		_hour.max_value = 23
		_hour.step = 1
		_hour.value_changed.connect(func(v): _set_time(int(v), int(_minute.value)))
		time_row.add_child(_hour)

		var colon := Label.new()
		colon.text = ":"
		time_row.add_child(colon)

		_minute = SpinBox.new()
		_minute.min_value = 0
		_minute.max_value = 59
		_minute.step = 1
		_minute.value_changed.connect(func(v): _set_time(int(_hour.value), int(v)))
		time_row.add_child(_minute)

func _refresh() -> void:
	_month_label.text = "%s %d" % [_month_name(_selected.month), _selected.year]

	# Sync dropdowns
	_year_opt.select(_year_opt.get_item_index(_selected.year))
	_month_opt.select(_month_opt.get_item_index(_selected.month))

	if show_time:
		_hour.value = _selected.hour
		_minute.value = _selected.minute

	# Rebuild grid days
	for c in _grid.get_children():
		c.queue_free()

	var first_dow := _day_of_week(_selected.year, _selected.month, 1) # 1=Mon..7=Sun
	var days_in_month := _days_in_month(_selected.year, _selected.month)

	# Fill leading blanks
	for _i in range(first_dow - 1):
		var blank := Control.new()
		blank.custom_minimum_size = Vector2(0, 30)
		_grid.add_child(blank)

	for d in range(1, days_in_month + 1):
		var b := Button.new()
		b.text = str(d)
		b.toggle_mode = true
		b.focus_mode = Control.FOCUS_ALL
		b.custom_minimum_size = Vector2(0, 30)
		var is_sel = (d == _selected.day)
		b.button_pressed = is_sel
		b.pressed.connect(func():
			_selected.day = d
			emit_signal("changed", _selected.duplicate(true))
			_refresh()
		)
		_grid.add_child(b)

func get_value() -> Dictionary:
	return _selected.duplicate(true)

func set_value(v: Dictionary) -> void:
	for k in ["year","month","day","hour","minute"]:
		if v.has(k):
			_selected[k] = int(v[k])
	emit_signal("changed", _selected.duplicate(true))
	_refresh()

# -------------------------
# Date math (simple + deterministic)
# -------------------------
func _add_month(delta: int) -> void:
	var y = _selected.year
	var m = _selected.month + delta
	while m < 1:
		m += 12
		y -= 1
	while m > 12:
		m -= 12
		y += 1
	_selected.year = clampi(y, start_year, end_year)
	_selected.month = m
	_selected.day = min(_selected.day, _days_in_month(_selected.year, _selected.month))
	emit_signal("changed", _selected.duplicate(true))
	_refresh()

func _set_year(y: int) -> void:
	_selected.year = y
	_selected.day = min(_selected.day, _days_in_month(_selected.year, _selected.month))
	emit_signal("changed", _selected.duplicate(true))
	_refresh()

func _set_month(m: int) -> void:
	_selected.month = m
	_selected.day = min(_selected.day, _days_in_month(_selected.year, _selected.month))
	emit_signal("changed", _selected.duplicate(true))
	_refresh()

func _set_time(h: int, mi: int) -> void:
	_selected.hour = clampi(h, 0, 23)
	_selected.minute = clampi(mi, 0, 59)
	emit_signal("changed", _selected.duplicate(true))

func _month_name(m: int) -> String:
	var names := ["","January","February","March","April","May","June","July","August","September","October","November","December"]
	return names[m]

func _is_leap(y: int) -> bool:
	return (y % 4 == 0 and y % 100 != 0) or (y % 400 == 0)

func _days_in_month(y: int, m: int) -> int:
	var d := [0,31,28,31,30,31,30,31,31,30,31,30,31]
	if m == 2 and _is_leap(y):
		return 29
	return d[m]

func _day_of_week(y: int, m: int, d: int) -> int:
	# Zeller-ish; returns 1=Mon..7=Sun
	var yy := y
	var mm := m
	if mm < 3:
		mm += 12
		yy -= 1
	var K := yy % 100
	var J := yy / 100
	var h := (d + int((13*(mm+1))/5) + K + int(K/4) + int(J/4) + 5*J) % 7
	# h: 0=Sat,1=Sun,2=Mon,...6=Fri
	var map := {0:6, 1:7, 2:1, 3:2, 4:3, 5:4, 6:5}
	return map[h]
