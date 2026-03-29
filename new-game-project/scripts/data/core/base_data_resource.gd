extends Resource
class_name BaseDataResource

@export var id: String = ""
@export var created_at_unix: int = 0
@export var updated_at_unix: int = 0

func touch() -> void:
	updated_at_unix = Time.get_unix_time_from_system()
	if created_at_unix <= 0:
		created_at_unix = updated_at_unix

func ensure_id(prefix: String = "res") -> String:
	if id.is_empty():
		id = "%s_%s" % [prefix, str(Time.get_ticks_usec())]
	return id

func is_valid() -> bool:
	return not id.is_empty()

func to_dict() -> Dictionary:
	return {
		"id": id,
		"created_at_unix": created_at_unix,
		"updated_at_unix": updated_at_unix
	}

func from_dict(data: Dictionary) -> void:
	id = str(data.get("id", ""))
	created_at_unix = int(data.get("created_at_unix", 0))
	updated_at_unix = int(data.get("updated_at_unix", 0))
