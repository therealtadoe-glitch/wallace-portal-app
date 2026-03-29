extends ScreenBase

@onready var _list: RichTextLabel = %InventoryLabel
@onready var _name: LineEdit = %NameInput
@onready var _category: LineEdit = %CategoryInput
@onready var _qty: SpinBox = %QtyInput
@onready var _min_qty: SpinBox = %MinQtyInput
@onready var _condition: LineEdit = %ConditionInput
@onready var _serial: LineEdit = %SerialInput
@onready var _notes: TextEdit = %NotesInput

func _ready() -> void:
	AppStore.data_changed.connect(_render)
	_render()

func _render() -> void:
	var lines: PackedStringArray = []
	for i in AppStore.state.inventory_items:
		var badge := "[LOW]" if i.is_low_stock() else ""
		lines.append("%s %s • %d/%d • %s" % [badge, i.item_name, i.quantity, i.minimum_quantity, i.category])
	_list.text = "\n".join(lines)

func _on_add_pressed() -> void:
	var item := InventoryItem.new()
	item.item_name = _name.text
	item.category = _category.text
	item.quantity = int(_qty.value)
	item.minimum_quantity = int(_min_qty.value)
	item.condition = _condition.text
	item.serial_number = _serial.text
	item.notes = _notes.text
	var err := AppStore.upsert_inventory(item)
	if err == "":
		_name.text = ""; _category.text = ""; _qty.value = 0; _min_qty.value = 0; _condition.text = "Good"; _serial.text = ""; _notes.text = ""
	else:
		AppStore.toast_requested.emit(err)
