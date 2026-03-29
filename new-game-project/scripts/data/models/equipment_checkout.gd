extends RefCounted
class_name EquipmentCheckout

var id: String = ""
var inventory_item_id: String = ""
var employee_id: String = ""
var checked_out_unix: int = 0
var expected_return_unix: int = 0
var actual_return_unix: int = 0
var condition_out: String = "Good"
var condition_in: String = ""
var notes: String = ""

func is_active() -> bool:
	return actual_return_unix == 0

func to_dict() -> Dictionary:
	return {
		"id": id,
		"inventory_item_id": inventory_item_id,
		"employee_id": employee_id,
		"checked_out_unix": checked_out_unix,
		"expected_return_unix": expected_return_unix,
		"actual_return_unix": actual_return_unix,
		"condition_out": condition_out,
		"condition_in": condition_in,
		"notes": notes
	}

static func from_dict(data: Dictionary) -> EquipmentCheckout:
	var c := EquipmentCheckout.new()
	c.id = data.get("id", "")
	c.inventory_item_id = data.get("inventory_item_id", "")
	c.employee_id = data.get("employee_id", "")
	c.checked_out_unix = int(data.get("checked_out_unix", 0))
	c.expected_return_unix = int(data.get("expected_return_unix", 0))
	c.actual_return_unix = int(data.get("actual_return_unix", 0))
	c.condition_out = data.get("condition_out", "Good")
	c.condition_in = data.get("condition_in", "")
	c.notes = data.get("notes", "")
	return c
