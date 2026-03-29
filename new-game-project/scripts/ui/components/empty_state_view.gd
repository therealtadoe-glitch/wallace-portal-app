extends VBoxContainer
class_name EmptyStateView

var _built: bool = false
var _title_label: Label
var _description_label: Label

func _ready() -> void:
	_build_if_needed()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	alignment = BoxContainer.ALIGNMENT_CENTER
	size_flags_vertical = Control.SIZE_EXPAND_FILL

	_title_label = Label.new()
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.text = "Nothing to show"
	add_child(_title_label)

	_description_label = Label.new()
	_description_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_description_label.modulate = Color(0.75, 0.75, 0.75)
	_description_label.text = "Try changing filters or add records."
	add_child(_description_label)

func set_content(title: String, description: String) -> void:
	_build_if_needed()
	_title_label.text = title
	_description_label.text = description
