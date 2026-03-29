extends HBoxContainer
class_name LabeledValueRow

var _built: bool = false
var _label_node: Label
var _value_node: Label

func _ready() -> void:
	_build_if_needed()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

	_label_node = Label.new()
	_label_node.custom_minimum_size = Vector2(140, 0)
	_label_node.modulate = Color(0.8, 0.8, 0.8)
	add_child(_label_node)

	_value_node = Label.new()
	_value_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_value_node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_value_node)

func set_values(label_text: String, value_text: String) -> void:
	_build_if_needed()
	_label_node.text = label_text
	_value_node.text = value_text
