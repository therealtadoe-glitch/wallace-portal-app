extends PanelContainer
class_name InventoryRow

var _built: bool = false
var _name_label: Label
var _qty_label: Label
var _status_label: Label
var _meta_label: Label

func _ready() -> void:
	_build_if_needed()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	custom_minimum_size = Vector2(0, 64)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 6)
	add_child(margin)

	var col := VBoxContainer.new()
	margin.add_child(col)

	var top := HBoxContainer.new()
	col.add_child(top)

	_name_label = Label.new()
	_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(_name_label)

	_qty_label = Label.new()
	top.add_child(_qty_label)

	_status_label = Label.new()
	col.add_child(_status_label)

	_meta_label = Label.new()
	_meta_label.modulate = Color(0.7, 0.7, 0.7)
	col.add_child(_meta_label)

func set_item(item: InventoryItemData) -> void:
	_build_if_needed()
	_name_label.text = item.name
	_qty_label.text = "%s %s" % [str(item.quantity), item.unit]
	_status_label.text = AppEnums.display_name("InventoryStatus", item.get_status())
	_meta_label.text = "Category: %s | SKU: %s | Vendor: %s" % [item.category, item.sku, item.vendor]
