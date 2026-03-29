extends PanelContainer
class_name EmployeeRow

var _built: bool = false
var _name_label: Label
var _role_label: Label
var _status_label: Label
var _contact_label: Label

func _ready() -> void:
	_build_if_needed()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	custom_minimum_size = Vector2(0, 72)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 6)
	add_child(margin)

	var col := VBoxContainer.new()
	margin.add_child(col)

	var top := HBoxContainer.new()
	col.add_child(top)

	_name_label = Label.new()
	_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(_name_label)

	_status_label = Label.new()
	top.add_child(_status_label)

	_role_label = Label.new()
	_role_label.modulate = Color(0.8, 0.8, 0.8)
	col.add_child(_role_label)

	_contact_label = Label.new()
	_contact_label.modulate = Color(0.72, 0.72, 0.72)
	col.add_child(_contact_label)

func set_employee(employee: EmployeeData, role_name: String = "") -> void:
	_build_if_needed()
	var full_name := employee.get_full_name()
	if full_name.is_empty():
		full_name = employee.employee_id
	_name_label.text = full_name
	_role_label.text = "Role: %s" % (role_name if not role_name.is_empty() else employee.role_id)
	_status_label.text = AppEnums.display_name("EmployeeStatus", employee.status)
	_contact_label.text = "%s  |  %s" % [employee.phone, employee.email]
