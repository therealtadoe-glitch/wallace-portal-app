extends RefCounted
class_name AppState

const CURRENT_VERSION := 1

var schema_version: int = CURRENT_VERSION
var employees: Array[Employee] = []
var shifts: Array[Shift] = []
var inventory_items: Array[InventoryItem] = []
var checkouts: Array[EquipmentCheckout] = []
var jobs: Array[JobTicket] = []

func to_dict() -> Dictionary:
	var dict := {
		"schema_version": schema_version,
		"employees": [],
		"shifts": [],
		"inventory_items": [],
		"checkouts": [],
		"jobs": []
	}
	for e in employees:
		dict["employees"].append(e.to_dict())
	for s in shifts:
		dict["shifts"].append(s.to_dict())
	for i in inventory_items:
		dict["inventory_items"].append(i.to_dict())
	for c in checkouts:
		dict["checkouts"].append(c.to_dict())
	for j in jobs:
		dict["jobs"].append(j.to_dict())
	return dict

static func from_dict(data: Dictionary) -> AppState:
	var state := AppState.new()
	state.schema_version = int(data.get("schema_version", 1))
	for raw in data.get("employees", []):
		state.employees.append(Employee.from_dict(raw))
	for raw in data.get("shifts", []):
		state.shifts.append(Shift.from_dict(raw))
	for raw in data.get("inventory_items", []):
		state.inventory_items.append(InventoryItem.from_dict(raw))
	for raw in data.get("checkouts", []):
		state.checkouts.append(EquipmentCheckout.from_dict(raw))
	for raw in data.get("jobs", []):
		state.jobs.append(JobTicket.from_dict(raw))
	state._migrate_if_needed()
	return state

func _migrate_if_needed() -> void:
	if schema_version < CURRENT_VERSION:
		schema_version = CURRENT_VERSION
