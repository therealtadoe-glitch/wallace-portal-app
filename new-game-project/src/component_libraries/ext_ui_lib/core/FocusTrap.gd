@tool
extends Node
class_name FocusTrap
## Keeps keyboard focus inside a given Control subtree (useful for modals on desktop).
##
## Usage:
##   var trap := FocusTrap.new()
##   trap.target = my_modal
##   add_child(trap)

var target: Control

func _unhandled_key_input(event: InputEvent) -> void:
	if not target:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_TAB:
		get_viewport().set_input_as_handled()
		_cycle_focus(event.shift_pressed)

func _cycle_focus(backwards: bool) -> void:
	var focusables := []
	_collect_focusables(target, focusables)
	if focusables.is_empty():
		return
	var current := get_viewport().gui_get_focus_owner()
	var idx := focusables.find(current)
	if idx == -1:
		focusables[0].grab_focus()
		return
	var next := (idx - 1) if backwards else (idx + 1)
	next = wrapi(next, 0, focusables.size())
	focusables[next].grab_focus()

func _collect_focusables(n: Node, out: Array) -> void:
	if n is Control:
		var c := n as Control
		if c.visible and c.focus_mode != Control.FOCUS_NONE and c.mouse_filter != Control.MOUSE_FILTER_IGNORE:
			out.append(c)
	for ch in n.get_children():
		_collect_focusables(ch, out)
