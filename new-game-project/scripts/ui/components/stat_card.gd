extends PanelContainer
class_name StatCard

var _built: bool = false
var _title_label: Label
var _value_label: Label

func _ready() -> void:
	_build_if_needed()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	custom_minimum_size = Vector2(180, 90)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 8)
	add_child(margin)

	var root := VBoxContainer.new()
	margin.add_child(root)

	_title_label = Label.new()
	_title_label.modulate = Color(0.8, 0.8, 0.8)
	root.add_child(_title_label)

	_value_label = Label.new()
	_value_label.text = "0"
	root.add_child(_value_label)

func set_stat(title: String, value: String) -> void:
	_build_if_needed()
	_title_label.text = title
	_value_label.text = value
