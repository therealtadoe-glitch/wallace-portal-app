@tool
extends PanelContainer
class_name AppWindowPanel
## A "fake window" panel: titlebar, close button, optional drag and resize.
##
## Great for desktop-style in-app panels. On mobile you can disable drag/resize and use full-screen.

signal closed
signal moved(new_position: Vector2)

@export var title: String = "Window"
@export var draggable := true
@export var resizable := false
@export var min_size := Vector2(260, 160)

var _titlebar: PanelContainer
var _title_label: Label
var _content: MarginContainer
var _dragging := false
var _drag_offset := Vector2.ZERO

# Resize
var _resize_handle: Control
var _resizing := false
var _resize_start := Vector2.ZERO
var _size_start := Vector2.ZERO

func _ready() -> void:
	custom_minimum_size = min_size
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 0)
	add_child(root)

	_titlebar = PanelContainer.new()
	_titlebar.custom_minimum_size = Vector2(0, 34)
	_titlebar.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(_titlebar)

	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 8)
	_titlebar.add_child(hb)

	_title_label = Label.new()
	_title_label.text = title
	_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(_title_label)

	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.flat = true
	close_btn.custom_minimum_size = Vector2(34, 28)
	close_btn.pressed.connect(_on_close)
	hb.add_child(close_btn)

	_content = MarginContainer.new()
	_content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_content.add_theme_constant_override("margin_left", 10)
	_content.add_theme_constant_override("margin_top", 10)
	_content.add_theme_constant_override("margin_right", 10)
	_content.add_theme_constant_override("margin_bottom", 10)
	root.add_child(_content)

	if draggable:
		_titlebar.gui_input.connect(_on_title_input)

	if resizable:
		_resize_handle = Control.new()
		_resize_handle.mouse_filter = Control.MOUSE_FILTER_STOP
		_resize_handle.custom_minimum_size = Vector2(18, 18)
		add_child(_resize_handle)
		_resize_handle.anchor_left = 1
		_resize_handle.anchor_top = 1
		_resize_handle.anchor_right = 1
		_resize_handle.anchor_bottom = 1
		_resize_handle.offset_left = -18
		_resize_handle.offset_top = -18
		_resize_handle.offset_right = 0
		_resize_handle.offset_bottom = 0
		_resize_handle.gui_input.connect(_on_resize_input)

func set_content(c: Control) -> void:
	for ch in _content.get_children():
		ch.queue_free()
	_content.add_child(c)

func set_title(t: String) -> void:
	title = t
	if is_instance_valid(_title_label):
		_title_label.text = title

func _on_close() -> void:
	emit_signal("closed")
	queue_free()

func _on_title_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		_dragging = ev.pressed
		_drag_offset = get_global_mouse_position() - global_position
	if ev is InputEventMouseMotion and _dragging:
		global_position = get_global_mouse_position() - _drag_offset
		emit_signal("moved", global_position)
	if ev is InputEventScreenTouch:
		_dragging = ev.pressed
		_drag_offset = ev.position - global_position
	if ev is InputEventScreenDrag and _dragging:
		global_position = ev.position - _drag_offset
		emit_signal("moved", global_position)

func _on_resize_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		_resizing = ev.pressed
		_resize_start = get_global_mouse_position()
		_size_start = size
	if ev is InputEventMouseMotion and _resizing:
		var delta := get_global_mouse_position() - _resize_start
		size = Vector2(max(min_size.x, _size_start.x + delta.x), max(min_size.y, _size_start.y + delta.y))
	if ev is InputEventScreenTouch:
		_resizing = ev.pressed
		_resize_start = ev.position
		_size_start = size
	if ev is InputEventScreenDrag and _resizing:
		size = Vector2(max(min_size.x, _size_start.x + ev.relative.x), max(min_size.y, _size_start.y + ev.relative.y))
