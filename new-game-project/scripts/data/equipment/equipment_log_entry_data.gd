extends BaseDataResource
class_name EquipmentLogEntryData

@export var log_id: String = ""
@export var equipment_id: String = ""
@export var employee_id: String = ""
@export var action: AppEnums.EquipmentAction = AppEnums.EquipmentAction.CHECKOUT
@export var timestamp_unix: int = 0
@export_multiline var notes: String = ""

func _init() -> void:
	ensure_log_id()

func ensure_log_id() -> String:
	if log_id.is_empty():
		log_id = IdGenerator.make_id("elog")
		id = log_id
	if timestamp_unix <= 0:
		timestamp_unix = Time.get_unix_time_from_system()
	return log_id

func is_valid() -> bool:
	return ValidationUtils.is_non_empty(log_id) and ValidationUtils.is_non_empty(equipment_id) and timestamp_unix > 0

func to_dict() -> Dictionary:
	var data := super.to_dict()
	data.merge({
		"log_id": log_id,
		"equipment_id": equipment_id,
		"employee_id": employee_id,
		"action": action,
		"timestamp_unix": timestamp_unix,
		"notes": notes
	}, true)
	return data

func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	log_id = str(data.get("log_id", ""))
	equipment_id = str(data.get("equipment_id", ""))
	employee_id = str(data.get("employee_id", ""))
	action = int(data.get("action", AppEnums.EquipmentAction.CHECKOUT))
	timestamp_unix = int(data.get("timestamp_unix", 0))
	notes = str(data.get("notes", ""))
