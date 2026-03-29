extends PanelContainer
class_name EmployeeListScene

var _built: bool = false
var _header: SectionHeader
var _filter_bar: SearchFilterBar
var _scroll: ScrollContainer
var _list_root: VBoxContainer
var _empty_state: EmptyStateView

var _employees: Array[EmployeeData] = []
var _role_by_id: Dictionary = {}
var _search_text: String = ""
var _status_filter: int = 0
var _sort_mode: int = 0

func _ready() -> void:
	_build_if_needed()
	_wire()
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
	_header.set_title("Employees")
	_header.set_subtitle("Directory")
	root.add_child(_header)

	_filter_bar = SearchFilterBar.new()
	_filter_bar.set_filter_options(PackedStringArray(["All", "Active", "Inactive", "On Leave", "Terminated"]))
	_filter_bar.set_sort_options(PackedStringArray(["Name A-Z", "Name Z-A", "Pay Low-High", "Pay High-Low"]))
	root.add_child(_filter_bar)

	_scroll = ScrollContainer.new()
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(_scroll)

	_list_root = VBoxContainer.new()
	_list_root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_list_root.add_theme_constant_override("separation", 6)
	_scroll.add_child(_list_root)

	_empty_state = EmptyStateView.new()
	_empty_state.set_content("No employees", "No records match your current search/filter settings.")
	root.add_child(_empty_state)

func _wire() -> void:
	if not _filter_bar.search_changed.is_connected(_on_search_changed):
		_filter_bar.search_changed.connect(_on_search_changed)
	if not _filter_bar.filter_changed.is_connected(_on_filter_changed):
		_filter_bar.filter_changed.connect(_on_filter_changed)
	if not _filter_bar.sort_changed.is_connected(_on_sort_changed):
		_filter_bar.sort_changed.connect(_on_sort_changed)

func set_employees(employees: Array[EmployeeData], roles: Array[RoleData] = []) -> void:
	_employees = employees.duplicate()
	_role_by_id.clear()
	for role in roles:
		_role_by_id[role.role_id] = role.name
	refresh()

func refresh() -> void:
	_build_if_needed()
	clear_list()
	var filtered := _apply_filters(_employees)
	for employee in filtered:
		_list_root.add_child(create_employee_row(employee))
	_empty_state.visible = filtered.is_empty()
	_scroll.visible = not filtered.is_empty()
	_header.set_subtitle("%d shown" % filtered.size())

func clear_list() -> void:
	for child in _list_root.get_children():
		child.queue_free()

func create_employee_row(employee: EmployeeData) -> EmployeeRow:
	var row := EmployeeRow.new()
	var role_name := str(_role_by_id.get(employee.role_id, ""))
	row.set_employee(employee, role_name)
	return row

func _apply_filters(source: Array[EmployeeData]) -> Array[EmployeeData]:
	var out: Array[EmployeeData] = []
	for employee in source:
		if not _matches_search(employee):
			continue
		if not _matches_status(employee):
			continue
		out.append(employee)
	_apply_sort(out)
	return out

func _matches_search(employee: EmployeeData) -> bool:
	if _search_text.is_empty():
		return true
	var haystack := (employee.get_full_name() + " " + employee.email + " " + employee.phone).to_lower()
	return haystack.contains(_search_text)

func _matches_status(employee: EmployeeData) -> bool:
	if _status_filter == 0:
		return true
	return employee.status == (_status_filter - 1)

func _apply_sort(items: Array[EmployeeData]) -> void:
	items.sort_custom(func(a: EmployeeData, b: EmployeeData) -> bool:
		match _sort_mode:
			1:
				return a.get_full_name().to_lower() > b.get_full_name().to_lower()
			2:
				return a.pay_rate < b.pay_rate
			3:
				return a.pay_rate > b.pay_rate
			_:
				return a.get_full_name().to_lower() < b.get_full_name().to_lower()
	)

func _on_search_changed(text: String) -> void:
	_search_text = text.strip_edges().to_lower()
	refresh()

func _on_filter_changed(index: int, _text: String) -> void:
	_status_filter = index
	refresh()

func _on_sort_changed(index: int, _text: String) -> void:
	_sort_mode = index
	refresh()
