extends BaseDataResource
class_name InventoryItemData

@export var item_id: String = ""
@export var name: String = ""
@export var category: String = ""
@export var quantity: float = 0.0
@export var unit: String = ""
@export var reorder_threshold: float = 0.0
@export var cost_per_unit: float = 0.0
@export var vendor: String = ""
@export var sku: String = ""
@export_multiline var notes: String = ""
@export var active: bool = true

func _init() -> void:
	ensure_item_id()

func ensure_item_id() -> String:
	if item_id.is_empty():
		item_id = IdGenerator.make_id("item")
		id = item_id
	return item_id

func get_status() -> AppEnums.InventoryStatus:
	if not active:
		return AppEnums.InventoryStatus.DISCONTINUED
	if quantity <= 0.0:
		return AppEnums.InventoryStatus.OUT_OF_STOCK
	if quantity <= reorder_threshold:
		return AppEnums.InventoryStatus.LOW_STOCK
	return AppEnums.InventoryStatus.IN_STOCK

func should_reorder() -> bool:
	return get_status() in [AppEnums.InventoryStatus.OUT_OF_STOCK, AppEnums.InventoryStatus.LOW_STOCK]

func is_valid() -> bool:
	return ValidationUtils.is_non_empty(item_id) and ValidationUtils.is_non_empty(name) and quantity >= 0.0 and reorder_threshold >= 0.0 and cost_per_unit >= 0.0

func to_dict() -> Dictionary:
	var data := super.to_dict()
	data.merge({
		"item_id": item_id,
		"name": name,
		"category": category,
		"quantity": quantity,
		"unit": unit,
		"reorder_threshold": reorder_threshold,
		"cost_per_unit": cost_per_unit,
		"vendor": vendor,
		"sku": sku,
		"notes": notes,
		"active": active
	}, true)
	return data

func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	item_id = str(data.get("item_id", ""))
	name = str(data.get("name", ""))
	category = str(data.get("category", ""))
	quantity = float(data.get("quantity", 0.0))
	unit = str(data.get("unit", ""))
	reorder_threshold = float(data.get("reorder_threshold", 0.0))
	cost_per_unit = float(data.get("cost_per_unit", 0.0))
	vendor = str(data.get("vendor", ""))
	sku = str(data.get("sku", ""))
	notes = str(data.get("notes", ""))
	active = bool(data.get("active", true))
