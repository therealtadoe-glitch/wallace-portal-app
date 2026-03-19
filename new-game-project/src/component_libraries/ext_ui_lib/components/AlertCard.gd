@tool
extends PanelContainer
class_name AlertCard
## A compact alert panel (for embedding in any layout).
##
## Editor-friendly: changing exported properties updates immediately.

signal primary_pressed
signal secondary_pressed

@export var title: String = "Alert":
	set(v):
		title = v
		_update_text()
@export var body: String = "Something happened.":
	set(v):
		body = v
		_update_text()
@export var primary_text: String = "OK":
	set(v):
		primary_text = v
		_update_buttons()
@export var secondary_text: String = "":
	set(v):
		secondary_text = v
		_update_buttons()

@export var tokens: UIStyleTokens = UIStyleTokens.new()

var _title_label: Label
var _body_label: Label
var _primary: Button
var _secondary: Button

func _ready() -> void:
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", int(tokens.space_m))
	add_child(v)

	_title_label = Label.new()
	_title_label.text = title
	_title_label.add_theme_font_size_override("font_size", tokens.subtitle_size)
	v.add_child(_title_label)

	_body_label = Label.new()
	_body_label.text = body
	_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_body_label.add_theme_font_size_override("font_size", tokens.body_size)
	v.add_child(_body_label)

	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_END
	buttons.add_theme_constant_override("separation", int(tokens.space_s))
	v.add_child(buttons)

	_secondary = Button.new()
	_secondary.text = secondary_text
	_secondary.visible = secondary_text.strip_edges() != ""
	_secondary.pressed.connect(emit_signal.bind("secondary_pressed"))
	buttons.add_child(_secondary)

	_primary = Button.new()
	_primary.text = primary_text
	_primary.pressed.connect(emit_signal.bind("primary_pressed"))
	buttons.add_child(_primary)

func _update_text() -> void:
	if not is_inside_tree():
		return
	if not is_instance_valid(_title_label):
		_build()
		return
	_title_label.text = title
	_body_label.text = body

func _update_buttons() -> void:
	if not is_inside_tree():
		return
	if not is_instance_valid(_primary):
		_build()
		return
	_primary.text = primary_text
	_secondary.text = secondary_text
	_secondary.visible = secondary_text.strip_edges() != ""
