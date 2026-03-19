@tool
extends Control
class_name ToastManager
## Toast / snackbar manager.
##
## Drop this onto a Control at your UI root (top-level).
## Call:
##   $ToastManager.toast("Saved!", 2.0)
##
## Desktop: top-right stack.
## Mobile: bottom stack (more thumb-friendly).

signal toast_clicked(id: int)

var _next_id := 1
var _container: VBoxContainer
var use_bottom := false
var max_toasts := 4

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	anchor_left = 0
	anchor_top = 0
	anchor_right = 1
	anchor_bottom = 1
	offset_left = 0
	offset_top = 0
	offset_right = 0
	offset_bottom = 0

	_container = VBoxContainer.new()
	_container.name = "ToastStack"
	_container.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(_container)

	_update_layout()

	#$ToastManager.toast("Undo?", 5.0, "Undo", func(): print("undo"))


func set_touch_mode(is_touch: bool) -> void:
	use_bottom = is_touch
	_update_layout()

func _update_layout() -> void:
	_container.anchor_left = 1.0
	_container.anchor_right = 1.0
	_container.anchor_top = 0.0
	_container.anchor_bottom = 0.0
	_container.offset_right = -16
	_container.offset_left = -320
	_container.offset_top = 16
	_container.offset_bottom = 16

	if use_bottom:
		_container.anchor_left = 0.5
		_container.anchor_right = 0.5
		_container.anchor_top = 1.0
		_container.anchor_bottom = 1.0
		_container.offset_left = -180
		_container.offset_right = 180
		_container.offset_top = -16
		_container.offset_bottom = -16

func toast(text: String, seconds := 2.5, action_text := "", action := Callable()) -> int:
	var id := _next_id
	_next_id += 1

	# Trim stack
	while _container.get_child_count() >= max_toasts:
		_container.get_child(0).queue_free()

	var card := PanelContainer.new()
	card.name = "Toast_%d" % id
	card.mouse_filter = MOUSE_FILTER_STOP
	card.custom_minimum_size = Vector2(0, 44)

	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 10)
	card.add_child(h)

	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(label)

	var btn: Button = null
	if action_text.strip_edges() != "":
		btn = Button.new()
		btn.text = action_text
		btn.flat = true
		btn.focus_mode = Control.FOCUS_ALL
		h.add_child(btn)
		btn.pressed.connect(func():
			if action.is_valid():
				action.call()
			_remove_toast(card)
		)

	_container.add_child(card)

	# Click anywhere to dismiss (and emit)
	card.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("toast_clicked", id)
			_remove_toast(card)
		if ev is InputEventScreenTouch and ev.pressed:
			emit_signal("toast_clicked", id)
			_remove_toast(card)
	)

	# Auto-remove timer
	var t := Timer.new()
	t.one_shot = true
	t.wait_time = max(0.1, seconds)
	card.add_child(t)
	t.timeout.connect(func(): _remove_toast(card))
	t.start()

	# Tiny pop-in animation
	card.modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(card, "modulate:a", 1.0, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	return id

func _remove_toast(card: Control) -> void:
	if not is_instance_valid(card):
		return
	var tw := create_tween()
	tw.tween_property(card, "modulate:a", 0.0, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tw.tween_callback(card.queue_free)
