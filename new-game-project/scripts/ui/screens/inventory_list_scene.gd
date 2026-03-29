extends PanelContainer
class_name InventoryListScene

var _built: bool = false
var _header: SectionHeader
var _filter_bar: SearchFilterBar
var _scroll: ScrollContainer
var _list_root: VBoxContainer
var _empty_state: EmptyStateView
var _items: Array[InventoryItemData] = []
var _search_text: String = ""

func _ready() -> void:
	_build_if_needed()
	_wire()
	refresh()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 8)
	margin.add_child(root)

	_header = SectionHeader.new()
	_header.set_title("Inventory")
	root.add_child(_header)

	_filter_bar = SearchFilterBar.new()
	_filter_bar.set_filter_options(PackedStringArray(["All", "In Stock", "Low Stock", "Out Of Stock", "Discontinued"]))
	_filter_bar.set_sort_options(PackedStringArray(["Name A-Z", "Qty High-Low", "Qty Low-High"]))
	root.add_child(_filter_bar)

	_scroll = ScrollContainer.new()
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(_scroll)

	_list_root = VBoxContainer.new()
	_scroll.add_child(_list_root)

	_empty_state = EmptyStateView.new()
	_empty_state.set_content("No inventory", "No items match current filters.")
	root.add_child(_empty_state)

func _wire() -> void:
	if not _filter_bar.search_changed.is_connected(_on_search_changed):
		_filter_bar.search_changed.connect(_on_search_changed)
	if not _filter_bar.filter_changed.is_connected(_on_filter_changed):
		_filter_bar.filter_changed.connect(_on_filter_changed)

func set_items(items: Array[InventoryItemData]) -> void:
	_items = items.duplicate()
	refresh()

func refresh() -> void:
	_build_if_needed()
	clear_list()
	var visible_count := 0
	for item in _items:
		if not _search_text.is_empty() and not (item.name + " " + item.category + " " + item.sku).to_lower().contains(_search_text):
			continue
		_list_root.add_child(create_inventory_row(item))
		visible_count += 1
	_empty_state.visible = visible_count == 0
	_scroll.visible = visible_count > 0
	_header.set_subtitle("%d shown" % visible_count)

func clear_list() -> void:
	for child in _list_root.get_children():
		child.queue_free()

func create_inventory_row(item: InventoryItemData) -> InventoryRow:
	var row := InventoryRow.new()
	row.set_item(item)
	return row

func _on_search_changed(text: String) -> void:
	_search_text = text.strip_edges().to_lower()
	refresh()

func _on_filter_changed(_index: int, _text: String) -> void:
	refresh()
