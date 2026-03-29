extends PanelContainer
class_name EquipmentRow

var _built: bool = false
var _name_label: Label
var _checkout_label: Label
var _condition_label: Label
var _meta_label: Label

func _ready() -> void:
	_build_if_needed()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	custom_minimum_size = Vector2(0, 64)

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

	_checkout_label = Label.new()
	top.add_child(_checkout_label)

	_condition_label = Label.new()
	col.add_child(_condition_label)

	_meta_label = Label.new()
	_meta_label.modulate = Color(0.7, 0.7, 0.7)
	col.add_child(_meta_label)

func set_equipment(item: EquipmentItemData, assignee_name: String = "") -> void:
	_build_if_needed()
	_name_label.text = "%s (%s)" % [item.name, item.equipment_type]
	_checkout_label.text = "Checked Out" if item.checked_out else "Available"
	_condition_label.text = "Condition: %s" % AppEnums.display_name("EquipmentCondition", item.condition)
	var assigned := assignee_name if not assignee_name.is_empty() else item.assigned_employee_id
	_meta_label.text = "Serial: %s | Assigned: %s" % [item.serial_number, assigned]
