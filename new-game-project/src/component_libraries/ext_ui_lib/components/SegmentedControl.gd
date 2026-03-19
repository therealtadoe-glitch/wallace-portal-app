@tool
extends PanelContainer
class_name SegmentedControl
## A segmented toggle control.
## Editor-friendly: changing segments rebuilds buttons.

signal changed(index: int, text: String)

@export var segments: Array[String] = ["One", "Two"]:
	set(v):
		segments = v
		_rebuild_deferred()
@export var selected := 0:
	set(v):
		selected = v
		_refresh()

@export var tokens: UIStyleTokens = UIStyleTokens.new()

var _buttons: Array[Button] = []

func _ready() -> void:
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()
	_buttons.clear()

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 0)
	add_child(hb)

	for i in segments.size():
		var b := Button.new()
		b.text = segments[i]
		b.toggle_mode = true
		b.focus_mode = Control.FOCUS_ALL
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(_on_pressed.bind(i))
		hb.add_child(b)
		_buttons.append(b)

	selected = clampi(selected, 0, max(0, segments.size() - 1))
	_refresh()

func _on_pressed(i: int) -> void:
	selected = i
	_refresh()
	emit_signal("changed", selected, segments[selected])

func _refresh() -> void:
	if _buttons.is_empty():
		return
	selected = clampi(selected, 0, max(0, segments.size() - 1))
	for i in _buttons.size():
		_buttons[i].button_pressed = (i == selected)

func _rebuild_deferred() -> void:
	if not is_inside_tree():
		return
	call_deferred("_build")
