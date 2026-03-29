extends RefCounted
class_name Validation

static func require_text(value: String, field: String) -> String:
	if value.strip_edges().is_empty():
		return "%s is required." % field
	return ""

static func require_non_negative(value: float, field: String) -> String:
	if value < 0.0:
		return "%s must be >= 0." % field
	return ""

static func is_valid_email(value: String) -> bool:
	return value.contains("@") and value.contains(".")
