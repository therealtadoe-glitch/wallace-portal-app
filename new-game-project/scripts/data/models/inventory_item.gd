extends RefCounted
class_name InventoryItem

var id: String = ""
var item_name: String = ""
var category: String = ""
var quantity: int = 0
var minimum_quantity: int = 0
var condition: String = "Good"
var serial_number: String = ""
var notes: String = ""
var active: bool = true

func is_low_stock() -> bool:
	return active and quantity <= minimum_quantity

func to_dict() -> Dictionary:
	return {
		"id": id,
		"item_name": item_name,
		"category": category,
		"quantity": quantity,
		"minimum_quantity": minimum_quantity,
		"condition": condition,
		"serial_number": serial_number,
		"notes": notes,
		"active": active
	}

static func from_dict(data: Dictionary) -> InventoryItem:
	var i := InventoryItem.new()
	i.id = data.get("id", "")
	i.item_name = data.get("item_name", "")
	i.category = data.get("category", "")
	i.quantity = int(data.get("quantity", 0))
	i.minimum_quantity = int(data.get("minimum_quantity", 0))
	i.condition = data.get("condition", "Good")
	i.serial_number = data.get("serial_number", "")
	i.notes = data.get("notes", "")
	i.active = bool(data.get("active", true))
	return i
