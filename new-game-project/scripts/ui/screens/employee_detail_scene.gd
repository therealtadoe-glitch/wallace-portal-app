extends PanelContainer
class_name EmployeeDetailScene

var _built: bool = false
var _header: SectionHeader
var _profile_name: Label
var _profile_role: Label
var _rows_container: VBoxContainer
var _equipment_list: VBoxContainer
var _timecard_list: VBoxContainer
var _employee: EmployeeData
var _role_name: String = ""
var _assigned_equipment: Array[EquipmentItemData] = []
var _recent_timecards: Array[TimecardData] = []

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
	_header.set_title("Employee Detail")
	root.add_child(_header)

	_profile_name = Label.new()
	root.add_child(_profile_name)

	_profile_role = Label.new()
	_profile_role.modulate = Color(0.8, 0.8, 0.8)
	root.add_child(_profile_role)

	_rows_container = VBoxContainer.new()
	_rows_container.add_theme_constant_override("separation", 4)
	root.add_child(_rows_container)

	var eq_header := SectionHeader.new()
	eq_header.set_title("Assigned Equipment")
	root.add_child(eq_header)
	_equipment_list = VBoxContainer.new()
	root.add_child(_equipment_list)

	var tc_header := SectionHeader.new()
	tc_header.set_title("Recent Timecards")
	root.add_child(tc_header)
	_timecard_list = VBoxContainer.new()
	root.add_child(_timecard_list)

func set_employee(employee: EmployeeData, role_name: String = "", assigned_equipment: Array[EquipmentItemData] = [], recent_timecards: Array[TimecardData] = []) -> void:
	_employee = employee
	_role_name = role_name
	_assigned_equipment = assigned_equipment.duplicate()
	_recent_timecards = recent_timecards.duplicate()
	refresh()

func refresh() -> void:
	_build_if_needed()
	_clear_box(_rows_container)
	_clear_box(_equipment_list)
	_clear_box(_timecard_list)

	if _employee == null:
		_profile_name.text = "No employee selected"
		_profile_role.text = ""
		return

	_profile_name.text = _employee.get_full_name()
	_profile_role.text = "Role: %s" % (_role_name if not _role_name.is_empty() else _employee.role_id)
	_header.set_subtitle(AppEnums.display_name("EmployeeStatus", _employee.status))

	_add_value(_rows_container, "Email", _employee.email)
	_add_value(_rows_container, "Phone", _employee.phone)
	_add_value(_rows_container, "Pay Rate", "$%.2f" % _employee.pay_rate)
	_add_value(_rows_container, "Hire Date (Unix)", str(_employee.hire_date_unix))
	_add_value(_rows_container, "Notes", _employee.notes)

	if _assigned_equipment.is_empty():
		_add_value(_equipment_list, "", "No assigned equipment")
	else:
		for item in _assigned_equipment:
			_add_value(_equipment_list, item.name, AppEnums.display_name("EquipmentCondition", item.condition))

	if _recent_timecards.is_empty():
		_add_value(_timecard_list, "", "No recent timecards")
	else:
		for card in _recent_timecards:
			_add_value(_timecard_list, card.timecard_id, "Hours: %.2f" % card.get_total_hours())

func _add_value(parent: VBoxContainer, label_text: String, value_text: String) -> void:
	var row := LabeledValueRow.new()
	row.set_values(label_text, value_text)
	parent.add_child(row)

func _clear_box(parent: VBoxContainer) -> void:
	for child in parent.get_children():
		child.queue_free()
