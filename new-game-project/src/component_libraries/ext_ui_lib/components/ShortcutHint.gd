@tool
extends HBoxContainer
class_name ShortcutHint
## Renders a platform-ish shortcut hint like: Ctrl + S
## Editor-friendly: keys rebuild live.

@export var keys: Array[String] = ["Ctrl", "S"]:
	set(v):
		keys = v
		_rebuild_deferred()

@export var tokens: UIStyleTokens = UIStyleTokens.new()

func _ready() -> void:
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()
	add_theme_constant_override("separation", int(tokens.space_xs))

	for i in keys.size():
		var k := Label.new()
		k.text = " %s " % keys[i]
		k.add_theme_color_override("font_color", Color(1,1,1))
		k.add_theme_stylebox_override("normal", _key_stylebox())
		add_child(k)

		if i < keys.size() - 1:
			var plus := Label.new()
			plus.text = "+"
			plus.modulate = tokens.text_muted
			add_child(plus)

func _key_stylebox() -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = tokens.surface_2
	sb.corner_radius_top_left = tokens.radius_s
	sb.corner_radius_top_right = tokens.radius_s
	sb.corner_radius_bottom_left = tokens.radius_s
	sb.corner_radius_bottom_right = tokens.radius_s
	sb.content_margin_left = int(tokens.space_s)
	sb.content_margin_right = int(tokens.space_s)
	sb.content_margin_top = 2
	sb.content_margin_bottom = 2
	sb.border_color = Color(1,1,1,0.12)
	sb.border_width_left = 1
	sb.border_width_right = 1
	sb.border_width_top = 1
	sb.border_width_bottom = 1
	return sb

func _rebuild_deferred() -> void:
	if not is_inside_tree():
		return
	call_deferred("_build")
