@tool
extends PanelContainer
class_name EmptyState
## A reusable "nothing here yet" UI.
## Editor-friendly: exported changes update preview immediately.

signal primary_pressed
signal secondary_pressed

@export var icon_text := "🗂️":
	set(v):
		icon_text = v
		_update()
@export var headline := "Nothing here yet":
	set(v):
		headline = v
		_update()
@export var body := "Try creating your first item.":
	set(v):
		body = v
		_update()
@export var primary_text := "Create":
	set(v):
		primary_text = v
		_update()
@export var secondary_text := "":
	set(v):
		secondary_text = v
		_update()

@export var tokens: UIStyleTokens = UIStyleTokens.new()

var _icon: Label
var _headline: Label
var _body: Label
var _primary: Button
var _secondary: Button

func _ready() -> void:
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var v := VBoxContainer.new()
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_theme_constant_override("separation", int(tokens.space_m))
	add_child(v)

	_icon = Label.new()
	_icon.text = icon_text
	_icon.add_theme_font_size_override("font_size", 44)
	_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(_icon)

	_headline = Label.new()
	_headline.text = headline
	_headline.add_theme_font_size_override("font_size", tokens.title_size)
	_headline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(_headline)

	_body = Label.new()
	_body.text = body
	_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_body.add_theme_font_size_override("font_size", tokens.body_size)
	_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_body.modulate = tokens.text_muted
	v.add_child(_body)

	var hb := HBoxContainer.new()
	hb.alignment = BoxContainer.ALIGNMENT_CENTER
	hb.add_theme_constant_override("separation", int(tokens.space_s))
	v.add_child(hb)

	_primary = Button.new()
	_primary.text = primary_text
	_primary.pressed.connect(emit_signal.bind("primary_pressed"))
	hb.add_child(_primary)

	_secondary = Button.new()
	_secondary.text = secondary_text
	_secondary.visible = secondary_text.strip_edges() != ""
	_secondary.pressed.connect(emit_signal.bind("secondary_pressed"))
	hb.add_child(_secondary)

func _update() -> void:
	if not is_inside_tree():
		return
	if not is_instance_valid(_icon):
		_build()
		return
	_icon.text = icon_text
	_headline.text = headline
	_body.text = body
	_primary.text = primary_text
	_secondary.text = secondary_text
	_secondary.visible = secondary_text.strip_edges() != ""
