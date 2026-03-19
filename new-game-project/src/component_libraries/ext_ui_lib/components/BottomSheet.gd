@tool
extends PanelContainer
class_name BottomSheet
## Mobile-style bottom sheet with drag to dismiss.
##
## Add this to AppModalLayer with centered=false.
## Example:
##   var sheet := BottomSheet.new()
##   sheet.set_title("Options")
##   sheet.set_content(my_control)
##   modal_layer.show_modal(sheet, false)

signal dismissed
signal opened

@export var title: String = "Sheet"
@export var can_dismiss := true
@export var peek_height := 340.0

var _root: VBoxContainer
var _handle: Control
var _title_label: Label
var _content_holder: MarginContainer

var _dragging := false
var _drag_start_y := 0.0
var _start_offset_y := 0.0

func _ready() -> void:
	_build()
	# Animate in
	var from := Vector2(position.x, position.y + 80)
	position = from
	modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 0.15)
	tw.tween_property(self, "position:y", position.y - 80, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	emit_signal("opened")

func _build() -> void:
	for c in get_children():
		c.queue_free()

	# Layout: anchor to bottom
	anchor_left = 0.0
	anchor_right = 1.0
	anchor_top = 1.0
	anchor_bottom = 1.0
	offset_left = 0
	offset_right = 0
	offset_bottom = 0
	offset_top = -peek_height

	_root = VBoxContainer.new()
	_root.add_theme_constant_override("separation", 8)
	add_child(_root)

	_handle = Control.new()
	_handle.custom_minimum_size = Vector2(0, 18)
	_handle.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(_handle)

	var handle_bar := ColorRect.new()
	handle_bar.color = Color(1, 1, 1, 0.25)
	handle_bar.custom_minimum_size = Vector2(56, 4)
	handle_bar.position = Vector2(0, 0)
	_handle.add_child(handle_bar)
	handle_bar.anchor_left = 0.5
	handle_bar.anchor_right = 0.5
	handle_bar.anchor_top = 0.5
	handle_bar.anchor_bottom = 0.5
	handle_bar.offset_left = -28
	handle_bar.offset_right = 28
	handle_bar.offset_top = -2
	handle_bar.offset_bottom = 2

	_title_label = Label.new()
	_title_label.text = title
	_title_label.add_theme_font_size_override("font_size", 18)
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_root.add_child(_title_label)

	_content_holder = MarginContainer.new()
	_content_holder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_content_holder.add_theme_constant_override("margin_left", 12)
	_content_holder.add_theme_constant_override("margin_right", 12)
	_content_holder.add_theme_constant_override("margin_bottom", 12)
	_root.add_child(_content_holder)

	_handle.gui_input.connect(_on_handle_input)

func set_title(t: String) -> void:
	title = t
	if is_instance_valid(_title_label):
		_title_label.text = title

func set_content(c: Control) -> void:
	for ch in _content_holder.get_children():
		ch.queue_free()
	_content_holder.add_child(c)

func _on_handle_input(ev: InputEvent) -> void:
	if not can_dismiss:
		return
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		_dragging = ev.pressed
		_drag_start_y = ev.position.y
		_start_offset_y = offset_top
		if not ev.pressed:
			_snap()
	if ev is InputEventMouseMotion and _dragging:
		var dy = ev.position.y - _drag_start_y
		offset_top = min(_start_offset_y + dy, -64)  # don't drag above too much
	if ev is InputEventScreenTouch:
		_dragging = ev.pressed
		_drag_start_y = ev.position.y
		_start_offset_y = offset_top
		if not ev.pressed:
			_snap()
	if ev is InputEventScreenDrag and _dragging:
		offset_top = min(_start_offset_y + ev.relative.y, -64)

func _snap() -> void:
	# If dragged down enough, dismiss.
	if offset_top > -peek_height * 0.45:
		_dismiss()
		return
	# Otherwise snap back to open position.
	var tw := create_tween()
	tw.tween_property(self, "offset_top", -peek_height, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _dismiss() -> void:
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 0.0, 0.12)
	tw.tween_property(self, "offset_top", 0.0, 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tw.tween_callback(func():
		emit_signal("dismissed")
		_close_self()
	)

func _close_self() -> void:
	var p := get_parent()
	while p:
		if p is AppModalLayer:
			(p as AppModalLayer).close_modal(self)
			return
		p = p.get_parent()
	queue_free()
