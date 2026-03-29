extends HBoxContainer
class_name SectionHeader

var _built: bool = false
var _title_label: Label
var _subtitle_label: Label

func _ready() -> void:
	_build_if_needed()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

	_title_label = Label.new()
	_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_title_label.text = "Section"
	add_child(_title_label)

	_subtitle_label = Label.new()
	_subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_subtitle_label.modulate = Color(0.7, 0.7, 0.7)
	_subtitle_label.text = ""
	add_child(_subtitle_label)

func set_title(value: String) -> void:
	_build_if_needed()
	_title_label.text = value

func set_subtitle(value: String) -> void:
	_build_if_needed()
	_subtitle_label.text = value
