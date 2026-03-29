extends RefCounted
class_name IdGenerator

static func make_id(prefix: String) -> String:
	var unix := Time.get_unix_time_from_system()
	var ticks := Time.get_ticks_usec()
	return "%s_%d_%d" % [prefix.to_lower(), unix, ticks]
