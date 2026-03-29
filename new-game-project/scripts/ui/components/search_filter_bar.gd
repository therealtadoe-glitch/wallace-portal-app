extends HBoxContainer
class_name SearchFilterBar

signal search_changed(text: String)
signal filter_changed(index: int, text: String)
signal sort_changed(index: int, text: String)

var _built: bool = false
var _search_input: LineEdit
var _filter_select: OptionButton
var _sort_select: OptionButton

func _ready() -> void:
	_build_if_needed()
	_wire()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

	_search_input = LineEdit.new()
	_search_input.placeholder_text = "Search..."
	_search_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(_search_input)

	_filter_select = OptionButton.new()
	_filter_select.custom_minimum_size = Vector2(150, 0)
	_filter_select.add_item("All")
	add_child(_filter_select)

	_sort_select = OptionButton.new()
	_sort_select.custom_minimum_size = Vector2(150, 0)
	_sort_select.add_item("Default")
	add_child(_sort_select)

func _wire() -> void:
	if not _search_input.text_changed.is_connected(_on_search_changed):
		_search_input.text_changed.connect(_on_search_changed)
	if not _filter_select.item_selected.is_connected(_on_filter_selected):
		_filter_select.item_selected.connect(_on_filter_selected)
	if not _sort_select.item_selected.is_connected(_on_sort_selected):
		_sort_select.item_selected.connect(_on_sort_selected)

func set_filter_options(options: PackedStringArray) -> void:
	_build_if_needed()
	_filter_select.clear()
	for opt in options:
		_filter_select.add_item(opt)

func set_sort_options(options: PackedStringArray) -> void:
	_build_if_needed()
	_sort_select.clear()
	for opt in options:
		_sort_select.add_item(opt)

func get_search_text() -> String:
	return _search_input.text.strip_edges()

func _on_search_changed(value: String) -> void:
	emit_signal("search_changed", value)

func _on_filter_selected(index: int) -> void:
	emit_signal("filter_changed", index, _filter_select.get_item_text(index))

func _on_sort_selected(index: int) -> void:
	emit_signal("sort_changed", index, _sort_select.get_item_text(index))
