@tool
extends Control
class_name CustomUI

@export var tokens: UIStyleTokens = UIStyleTokens.new()
## Base class for all Custom UI components in this pack.
##
## Drop a script extending `CustomUI` onto an empty `Control` node.
## In `_ready()`, call `build()` which creates and wires all child nodes.

signal built

var _built := false
var touch_mode := false  ## If true, increase hit targets and reduce hover-only affordances.

func _ready() -> void:
	# By default, autodetect touch mode if running on mobile or if a touch screen is present.
	touch_mode = _autodetect_touch_mode()
	# Components can call build() when they are ready. Some may want to delay.
	pass

func build() -> void:
	if _built:
		return
	_built = true
	_build()
	emit_signal("built")

## Override in subclasses to create children, connect signals, set sizes/anchors.
func _build() -> void:
	pass

# -------------------------
# Helpers
# -------------------------
func ui_scale() -> float:
	# A simple DPI-ish scaling helper.
	# On desktop, allow users to scale your entire UI by setting ProjectSettings:
	#   display/window/stretch/scale
	# This function multiplies by that scale plus a small OS scale hint if available.
	var s := 1.0
	if ProjectSettings.has_setting("display/window/stretch/scale"):
		s *= float(ProjectSettings.get_setting("display/window/stretch/scale"))
	# Godot exposes an OS scale factor in 4.x via DisplayServer.
	if DisplayServer.has_method("screen_get_scale"):
		s *= DisplayServer.screen_get_scale(DisplayServer.window_get_current_screen())
	return s

func dp(px: float) -> float:
	# density-independent pixels.
	return px * ui_scale()

func safe_area() -> Rect2i:
	# Safe area for notches / rounded corners. On desktop this is usually the full window.
	# Godot 4: DisplayServer.screen_get_usable_rect() approximates a safe usable region.
	var screen := DisplayServer.window_get_current_screen()
	var r := DisplayServer.screen_get_usable_rect(screen)
	return Rect2i(r.position, r.size)

func make(node_type: String, name: String, parent: Node, props := {}) -> Node:
	var n := ClassDB.instantiate(node_type)
	n.name = name
	parent.add_child(n)
	for k in props.keys():
		n.set(k, props[k])
	return n

func anchor_full(c: Control) -> void:
	c.anchor_left = 0.0
	c.anchor_top = 0.0
	c.anchor_right = 1.0
	c.anchor_bottom = 1.0
	c.offset_left = 0
	c.offset_top = 0
	c.offset_right = 0
	c.offset_bottom = 0

func set_margins(c: Control, m: float) -> void:
	c.offset_left = m
	c.offset_top = m
	c.offset_right = -m
	c.offset_bottom = -m

func _autodetect_touch_mode() -> bool:
	if OS.has_feature("mobile"):
		return true
	# Desktop touch screens are trickier; treat a recent touch as touch mode in your app layer.
	return false


func rebuild() -> void:
	# Safe rebuild for @tool preview and runtime updates.
	_built = false
	for c in get_children():
		c.queue_free()
	build()

func _rebuild_deferred() -> void:
	call_deferred("rebuild")
