extends BaseDataResource
class_name EquipmentItemData

@export var equipment_id: String = ""
@export var name: String = ""
@export var equipment_type: String = ""
@export var serial_number: String = ""
@export var condition: AppEnums.EquipmentCondition = AppEnums.EquipmentCondition.GOOD
@export var assigned_employee_id: String = ""
@export var checked_out: bool = false
@export var purchase_date_unix: int = 0
@export_multiline var maintenance_notes: String = ""
@export var active: bool = true

func _init() -> void:
	ensure_equipment_id()

func ensure_equipment_id() -> String:
	if equipment_id.is_empty():
		equipment_id = IdGenerator.make_id("equip")
		id = equipment_id
	return equipment_id

func is_assignable() -> bool:
	return active and not checked_out and condition != AppEnums.EquipmentCondition.OUT_OF_SERVICE

func needs_maintenance() -> bool:
	return condition in [AppEnums.EquipmentCondition.NEEDS_REPAIR, AppEnums.EquipmentCondition.OUT_OF_SERVICE]

func assign_to(employee_id: String) -> void:
	assigned_employee_id = employee_id
	checked_out = not employee_id.is_empty()
	touch()

func is_valid() -> bool:
	return ValidationUtils.is_non_empty(equipment_id) and ValidationUtils.is_non_empty(name)

func to_dict() -> Dictionary:
	var data := super.to_dict()
	data.merge({
		"equipment_id": equipment_id,
		"name": name,
		"equipment_type": equipment_type,
		"serial_number": serial_number,
		"condition": condition,
		"assigned_employee_id": assigned_employee_id,
		"checked_out": checked_out,
		"purchase_date_unix": purchase_date_unix,
		"maintenance_notes": maintenance_notes,
		"active": active
	}, true)
	return data

func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	equipment_id = str(data.get("equipment_id", ""))
	name = str(data.get("name", ""))
	equipment_type = str(data.get("equipment_type", ""))
	serial_number = str(data.get("serial_number", ""))
	condition = int(data.get("condition", AppEnums.EquipmentCondition.GOOD))
	assigned_employee_id = str(data.get("assigned_employee_id", ""))
	checked_out = bool(data.get("checked_out", false))
	purchase_date_unix = int(data.get("purchase_date_unix", 0))
	maintenance_notes = str(data.get("maintenance_notes", ""))
	active = bool(data.get("active", true))
