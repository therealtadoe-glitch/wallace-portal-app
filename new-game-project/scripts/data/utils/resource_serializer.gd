extends RefCounted
class_name ResourceSerializer

static func save_resource_json(path: String, data: Resource) -> Error:
	var serialized := _resource_to_variant(data)
	var text := JSON.stringify(serialized, "\t")
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(text)
	return OK

static func load_json_to_dict(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed := JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		return parsed
	return {}

static func _resource_to_variant(value: Variant) -> Variant:
	if value is Resource and value.has_method("to_dict"):
		return value.to_dict()
	if value is Array:
		var out: Array = []
		for item in value:
			out.append(_resource_to_variant(item))
		return out
	if value is Dictionary:
		var out_dict: Dictionary = {}
		for key in value.keys():
			out_dict[key] = _resource_to_variant(value[key])
		return out_dict
	return value
