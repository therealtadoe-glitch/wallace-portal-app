extends PanelContainer
class_name EquipmentListScene

var _built: bool = false
var _header: SectionHeader
var _filter_bar: SearchFilterBar
var _scroll: ScrollContainer
var _list_root: VBoxContainer
var _empty_state: EmptyStateView
var _equipment: Array[EquipmentItemData] = []
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
	_header.set_title("Equipment")
	root.add_child(_header)

	_filter_bar = SearchFilterBar.new()
	_filter_bar.set_filter_options(PackedStringArray(["All", "Available", "Checked Out", "Needs Repair"]))
	root.add_child(_filter_bar)

	_scroll = ScrollContainer.new()
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(_scroll)
	_list_root = VBoxContainer.new()
	_scroll.add_child(_list_root)

	_empty_state = EmptyStateView.new()
	_empty_state.set_content("No equipment", "No equipment records match the current filter.")
	root.add_child(_empty_state)

func set_equipment(equipment: Array[EquipmentItemData], employees: Array[EmployeeData] = []) -> void:
	_equipment = equipment.duplicate()
	_employee_name_by_id.clear()
	for employee in employees:
		_employee_name_by_id[employee.employee_id] = employee.get_full_name()
	refresh()

func refresh() -> void:
	_build_if_needed()
	clear_list()
	var count := 0
	for item in _equipment:
		_list_root.add_child(create_equipment_row(item))
		count += 1
	_empty_state.visible = count == 0
	_scroll.visible = count > 0
	_header.set_subtitle("%d items" % count)

func clear_list() -> void:
	for child in _list_root.get_children():
		child.queue_free()

func create_equipment_row(item: EquipmentItemData) -> EquipmentRow:
	var row := EquipmentRow.new()
	row.set_equipment(item, str(_employee_name_by_id.get(item.assigned_employee_id, "")))
	return row
