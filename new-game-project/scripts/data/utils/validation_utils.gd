extends RefCounted
class_name ValidationUtils

static func is_non_empty(value: String) -> bool:
	return not value.strip_edges().is_empty()

static func is_valid_email(value: String) -> bool:
	if value.is_empty():
		return true
	return value.contains("@") and value.contains(".")

static func is_non_negative(value: float) -> bool:
	return value >= 0.0

static func has_unique_ids(resources: Array[Resource]) -> bool:
	var seen: Dictionary = {}
	for item in resources:
		if item == null or not item.has_method("get"):
			continue
		var rid := str(item.get("id"))
		if rid.is_empty() or seen.has(rid):
			return false
		seen[rid] = true
	return true
