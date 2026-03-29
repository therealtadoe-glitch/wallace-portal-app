extends RefCounted
class_name AppIdGenerator

static var _counter: int = 0

static func next(prefix: String) -> String:
	_counter += 1
	return "%s_%s_%d" % [prefix, Time.get_datetime_string_from_system().replace(":", "").replace("-", "").replace("T", ""), _counter]
