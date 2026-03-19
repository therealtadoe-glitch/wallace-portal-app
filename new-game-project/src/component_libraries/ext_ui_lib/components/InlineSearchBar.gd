@tool
extends PanelContainer
class_name InlineSearchBar
## Search bar with clear button + debounced signal.
## Editor-friendly: placeholder updates live.

signal search_changed(text: String)

@export var placeholder := "Search":
	set(v):
		placeholder = v
		if is_instance_valid(_edit):
			_edit.placeholder_text = placeholder
@export var debounce_seconds := 0.18

@export var tokens: UIStyleTokens = UIStyleTokens.new()

var _edit: LineEdit
var _timer: Timer

func _ready() -> void:
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", int(tokens.space_s))
	add_child(hb)

	var icon := Label.new()
	icon.text = "🔎"
	icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	icon.modulate = tokens.text_muted
	hb.add_child(icon)

	_edit = LineEdit.new()
	_edit.placeholder_text = placeholder
	_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(_edit)

	var clear := Button.new()
	clear.text = "✕"
	clear.flat = true
	clear.custom_minimum_size = Vector2(28, 28)
	clear.pressed.connect(func():
		_edit.text = ""
		_emit_debounced()
	)
	hb.add_child(clear)

	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.timeout.connect(func(): emit_signal("search_changed", _edit.text))

	_edit.text_changed.connect(func(_t): _emit_debounced())

func _emit_debounced() -> void:
	if not is_instance_valid(_timer):
		return
	_timer.stop()
	_timer.wait_time = max(0.05, debounce_seconds)
	_timer.start()

func get_text() -> String:
	return _edit.text if is_instance_valid(_edit) else ""

func set_text(t: String) -> void:
	if is_instance_valid(_edit):
		_edit.text = t
	_emit_debounced()
