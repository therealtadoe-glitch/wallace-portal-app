extends PanelContainer
class_name TimecardListScene

var _built: bool = false
var _header: SectionHeader
var _filter_bar: SearchFilterBar
var _scroll: ScrollContainer
var _list_root: VBoxContainer
var _empty_state: EmptyStateView
var _timecards: Array[TimecardData] = []
var _employee_name_by_id: Dictionary = {}

func _ready() -> void:
	_build_if_needed()
	refresh()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 8)
	margin.add_child(root)

	_header = SectionHeader.new()
	_header.set_title("Timecards")
	root.add_child(_header)

	_filter_bar = SearchFilterBar.new()
	_filter_bar.set_filter_options(PackedStringArray(["All", "Open", "Closed"]))
	root.add_child(_filter_bar)

	_scroll = ScrollContainer.new()
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(_scroll)
	_list_root = VBoxContainer.new()
	_scroll.add_child(_list_root)

	_empty_state = EmptyStateView.new()
	_empty_state.set_content("No timecards", "No timecard records are available.")
	root.add_child(_empty_state)

func set_timecards(timecards: Array[TimecardData], employees: Array[EmployeeData] = []) -> void:
	_timecards = timecards.duplicate()
	_employee_name_by_id.clear()
	for employee in employees:
		_employee_name_by_id[employee.employee_id] = employee.get_full_name()
	refresh()

func refresh() -> void:
	_build_if_needed()
	clear_list()
	for card in _timecards:
		var row := LabeledValueRow.new()
		var employee_name := str(_employee_name_by_id.get(card.employee_id, card.employee_id))
		var status := "Open" if card.is_open() else "Closed"
		row.set_values(employee_name, "%s | %.2f hrs | %s" % [card.timecard_id, card.get_total_hours(), status])
		_list_root.add_child(row)
	_empty_state.visible = _timecards.is_empty()
	_scroll.visible = not _timecards.is_empty()
	_header.set_subtitle("%d records" % _timecards.size())

func clear_list() -> void:
	for child in _list_root.get_children():
		child.queue_free()
