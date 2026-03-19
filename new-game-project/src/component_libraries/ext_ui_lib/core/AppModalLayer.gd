@tool
extends CanvasLayer
class_name AppModalLayer
## A singleton-friendly modal overlay that hosts dialogs, bottom sheets, etc.
##
## Add this node near your UI root. Then call:
##   AppModalLayer.show_modal(my_control)
## or use AppAlertDialog which wraps this.

signal modal_opened(modal: Control)
signal modal_closed(modal: Control)

var dimmer: ColorRect
var stack: VBoxContainer

var close_on_background := true

func _ready() -> void:
	layer = 100  # above typical UI
	dimmer = ColorRect.new()
	dimmer.color = Color(0, 0, 0, 0.45)
	dimmer.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dimmer)
	dimmer.anchor_left = 0
	dimmer.anchor_top = 0
	dimmer.anchor_right = 1
	dimmer.anchor_bottom = 1
	dimmer.offset_left = 0
	dimmer.offset_top = 0
	dimmer.offset_right = 0
	dimmer.offset_bottom = 0

	stack = VBoxContainer.new()
	stack.name = "ModalStack"
	stack.anchor_left = 0.5
	stack.anchor_top = 0.5
	stack.anchor_right = 0.5
	stack.anchor_bottom = 0.5
	stack.offset_left = -240
	stack.offset_top = -140
	stack.offset_right = 240
	stack.offset_bottom = 140
	stack.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(stack)

	dimmer.gui_input.connect(_on_dimmer_input)
	_update_visibility()

func show_modal(modal: Control, centered := true) -> void:
	# Wrap in a container so we can animate and stack nicely.
	var holder := CenterContainer.new()
	holder.name = "ModalHolder"
	holder.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	holder.size_flags_vertical = Control.SIZE_EXPAND_FILL

	if centered:
		holder.add_child(modal)
	else:
		holder.add_child(modal)

	stack.add_child(holder)
	_update_visibility()
	emit_signal("modal_opened", modal)
	_grab_initial_focus(modal)

func close_top() -> void:
	if stack.get_child_count() == 0:
		return
	var holder := stack.get_child(stack.get_child_count() - 1)
	var modal := holder.get_child(0) if holder.get_child_count() > 0 else null
	holder.queue_free()
	_update_visibility()
	if modal:
		emit_signal("modal_closed", modal)

func close_modal(modal: Control) -> void:
	for holder in stack.get_children():
		if holder.get_child_count() > 0 and holder.get_child(0) == modal:
			holder.queue_free()
			_update_visibility()
			emit_signal("modal_closed", modal)
			return

func is_open() -> bool:
	return stack.get_child_count() > 0

func _update_visibility() -> void:
	visible = is_open()

func _on_dimmer_input(event: InputEvent) -> void:
	if not close_on_background:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		close_top()
	if event is InputEventScreenTouch and event.pressed:
		close_top()

func _grab_initial_focus(modal: Control) -> void:
	# Try to focus a focusable child for keyboard UX.
	var focusable := _find_focusable(modal)
	if focusable:
		focusable.grab_focus()

func _find_focusable(n: Node) -> Control:
	if n is Control and (n as Control).focus_mode != Control.FOCUS_NONE:
		return n as Control
	for c in n.get_children():
		var f := _find_focusable(c)
		if f:
			return f
	return null
