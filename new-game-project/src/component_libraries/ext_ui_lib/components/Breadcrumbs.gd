@tool
extends HBoxContainer
class_name Breadcrumbs
## Clickable breadcrumb trail.
## Editor-friendly: items rebuild live.

signal item_activated(index: int, text: String)

@export var items: Array[String] = ["Home"]:
	set(v):
		items = v
		_rebuild_deferred()

@export var tokens: UIStyleTokens = UIStyleTokens.new()

func _ready() -> void:
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()
	add_theme_constant_override("separation", int(tokens.space_xs))

	for i in items.size():
		var b := Button.new()
		b.text = items[i]
		b.flat = true
		b.pressed.connect(emit_signal.bind("item_activated", i, items[i]))
		add_child(b)
		if i < items.size() - 1:
			var sep := Label.new()
			sep.text = "›"
			sep.modulate = tokens.text_muted
			add_child(sep)

func _rebuild_deferred() -> void:
	if not is_inside_tree():
		return
	call_deferred("_build")
