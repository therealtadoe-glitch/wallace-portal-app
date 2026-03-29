extends BaseDataResource
class_name RoleData

@export var role_id: String = ""
@export var name: String = ""
@export var capability_flags: PackedStringArray = []
@export var default_hourly_pay: float = 0.0
@export_multiline var description: String = ""

func _init() -> void:
	ensure_role_id()

func ensure_role_id() -> String:
	if role_id.is_empty():
		role_id = IdGenerator.make_id("role")
		id = role_id
	return role_id

func can(permission: String) -> bool:
	return capability_flags.has(permission)

func is_valid() -> bool:
	return ValidationUtils.is_non_empty(role_id) and ValidationUtils.is_non_empty(name) and ValidationUtils.is_non_negative(default_hourly_pay)

func to_dict() -> Dictionary:
	var data := super.to_dict()
	data.merge({
		"role_id": role_id,
		"name": name,
		"capability_flags": capability_flags,
		"default_hourly_pay": default_hourly_pay,
		"description": description
	}, true)
	return data

func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	role_id = str(data.get("role_id", ""))
	name = str(data.get("name", ""))
	capability_flags = PackedStringArray(data.get("capability_flags", PackedStringArray()))
	default_hourly_pay = float(data.get("default_hourly_pay", 0.0))
	description = str(data.get("description", ""))
