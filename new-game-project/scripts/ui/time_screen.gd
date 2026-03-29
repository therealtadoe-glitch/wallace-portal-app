extends ScreenBase

@onready var _employees: OptionButton = %EmployeeOption
@onready var _status: Label = %StatusLabel
@onready var _history: RichTextLabel = %HistoryLabel

func _ready() -> void:
	AppStore.data_changed.connect(_render)
	_render()

func _render() -> void:
	var keep := _employees.selected
	_employees.clear()
	for e in AppStore.state.employees:
		_employees.add_item(e.full_name)
	if _employees.item_count == 0:
		_status.text = "No employees available"
		_history.text = ""
		return
	_employees.selected = clampi(keep, 0, _employees.item_count - 1)
	_update_status()

func _selected_employee() -> Employee:
	if _employees.item_count == 0:
		return null
	return AppStore.state.employees[_employees.selected]

func _update_status() -> void:
	var e := _selected_employee()
	if e == null:
		return
	var shift := AppStore.active_shift_for_employee(e.id)
	_status.text = "Open Shift" if shift != null else "Not Clocked In"
	var lines: PackedStringArray = []
	for s in AppStore.state.shifts:
		if s.employee_id == e.id:
			lines.append("%s -> %s (%.2fh)" % [_fmt_time(s.clock_in_unix), _fmt_time(s.clock_out_unix), s.worked_hours()])
	_history.text = "\n".join(lines)

func _on_clock_in_pressed() -> void:
	var e := _selected_employee(); if e != null: AppStore.clock_in(e.id)

func _on_clock_out_pressed() -> void:
	var e := _selected_employee(); if e != null: AppStore.clock_out(e.id)

func _on_break_pressed() -> void:
	var e := _selected_employee(); if e != null: AppStore.toggle_break(e.id)

func _on_employee_option_item_selected(_idx: int) -> void:
	_update_status()
