extends ScreenBase

@onready var _item_opt: OptionButton = %ItemOption
@onready var _emp_opt: OptionButton = %EmployeeOption
@onready var _days: SpinBox = %DaysInput
@onready var _out_cond: LineEdit = %CondOutInput
@onready var _notes: TextEdit = %NotesInput
@onready var _active: RichTextLabel = %ActiveLabel
@onready var _history: RichTextLabel = %HistoryLabel

func _ready() -> void:
	AppStore.data_changed.connect(_render)
	_render()

func _render() -> void:
	_item_opt.clear(); _emp_opt.clear()
	for i in AppStore.state.inventory_items: _item_opt.add_item(i.item_name)
	for e in AppStore.state.employees: _emp_opt.add_item(e.full_name)
	var active_lines: PackedStringArray = []
	var history_lines: PackedStringArray = []
	for c in AppStore.state.checkouts:
		var item_name := _inventory_name(c.inventory_item_id)
		var employee_name := _employee_name(c.employee_id)
		var row := "%s -> %s (%s to %s)" % [item_name, employee_name, _fmt_time(c.checked_out_unix), _fmt_time(c.actual_return_unix)]
		if c.is_active(): active_lines.append("%s due %s" % [row, _fmt_time(c.expected_return_unix)])
		history_lines.append(row)
	_active.text = "\n".join(active_lines)
	_history.text = "\n".join(history_lines)

func _on_checkout_pressed() -> void:
	if _item_opt.item_count == 0 or _emp_opt.item_count == 0: return
	var item := AppStore.state.inventory_items[_item_opt.selected]
	var emp := AppStore.state.employees[_emp_opt.selected]
	var expected := int(Time.get_unix_time_from_system()) + int(_days.value) * 86400
	AppStore.checkout_equipment(item.id, emp.id, expected, _out_cond.text, _notes.text)

func _inventory_name(id: String) -> String:
	for i in AppStore.state.inventory_items:
		if i.id == id: return i.item_name
	return "Unknown"

func _employee_name(id: String) -> String:
	for e in AppStore.state.employees:
		if e.id == id: return e.full_name
	return "Unknown"
