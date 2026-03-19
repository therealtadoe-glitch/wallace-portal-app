@tool
extends PanelContainer
class_name AppAlertDialog
## Modal alert/confirm/prompt dialog that is designed to be hosted by AppModalLayer.
##
## Typical usage:
##   var dialog := AppAlertDialog.alert("Saved!", "Your changes were saved.")
##   modal_layer.show_modal(dialog)
##
## Or:
##   var d := AppAlertDialog.confirm("Delete file?", "This can't be undone.")
##   d.confirmed.connect(func(): ...)
##   modal_layer.show_modal(d)

signal confirmed
signal cancelled
signal submitted(text: String)

enum Mode { ALERT, CONFIRM, PROMPT }
var mode: Mode = Mode.ALERT

var _title := "Alert"
var _message := ""
var _ok_text := "OK"
var _cancel_text := "Cancel"
var _placeholder := ""

var _input: LineEdit

static func alert(title: String, message: String, ok_text := "OK") -> AppAlertDialog:
	var d := AppAlertDialog.new()
	d.mode = Mode.ALERT
	d._title = title
	d._message = message
	d._ok_text = ok_text
	return d

static func confirm(title: String, message: String, ok_text := "OK", cancel_text := "Cancel") -> AppAlertDialog:
	var d := AppAlertDialog.new()
	d.mode = Mode.CONFIRM
	d._title = title
	d._message = message
	d._ok_text = ok_text
	d._cancel_text = cancel_text
	return d

static func prompt(title: String, message: String, placeholder := "", ok_text := "OK", cancel_text := "Cancel") -> AppAlertDialog:
	var d := AppAlertDialog.new()
	d.mode = Mode.PROMPT
	d._title = title
	d._message = message
	d._placeholder = placeholder
	d._ok_text = ok_text
	d._cancel_text = cancel_text
	return d

func _ready() -> void:
	custom_minimum_size = Vector2(420, 0)
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 10)
	add_child(outer)

	var title_label := Label.new()
	title_label.text = _title
	title_label.add_theme_font_size_override("font_size", 20)
	outer.add_child(title_label)

	var msg := Label.new()
	msg.text = _message
	msg.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	outer.add_child(msg)

	_input = null
	if mode == Mode.PROMPT:
		_input = LineEdit.new()
		_input.placeholder_text = _placeholder
		outer.add_child(_input)
		_input.text_submitted.connect(_on_submit)

	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_END
	buttons.add_theme_constant_override("separation", 8)
	outer.add_child(buttons)

	if mode != Mode.ALERT:
		var cancel := Button.new()
		cancel.text = _cancel_text
		cancel.pressed.connect(_on_cancel)
		buttons.add_child(cancel)

	var ok := Button.new()
	ok.text = _ok_text
	ok.pressed.connect(_on_ok)
	buttons.add_child(ok)

func _on_ok() -> void:
	if mode == Mode.PROMPT and is_instance_valid(_input):
		emit_signal("submitted", _input.text)
	emit_signal("confirmed")
	_close_self()

func _on_cancel() -> void:
	emit_signal("cancelled")
	_close_self()

func _on_submit(text: String) -> void:
	emit_signal("submitted", text)
	emit_signal("confirmed")
	_close_self()

func _close_self() -> void:
	# If hosted by AppModalLayer, it can close us via close_modal(self).
	var p := get_parent()
	while p:
		if p is AppModalLayer:
			(p as AppModalLayer).close_modal(self)
			return
		p = p.get_parent()
	queue_free()
