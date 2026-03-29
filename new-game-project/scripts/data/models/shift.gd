extends RefCounted
class_name Shift

var id: String = ""
var employee_id: String = ""
var clock_in_unix: int = 0
var clock_out_unix: int = 0
var break_start_unix: int = 0
var break_end_unix: int = 0

func is_open() -> bool:
	return clock_in_unix > 0 and clock_out_unix == 0

func worked_hours() -> float:
	if clock_in_unix == 0:
		return 0.0
	var end_time := clock_out_unix if clock_out_unix > 0 else Time.get_unix_time_from_system()
	var total_seconds: float = float(max(0, end_time - clock_in_unix))
	if break_start_unix > 0 and break_end_unix > break_start_unix:
		total_seconds -= float(break_end_unix - break_start_unix)
	return total_seconds / 3600.0

func to_dict() -> Dictionary:
	return {
		"id": id,
		"employee_id": employee_id,
		"clock_in_unix": clock_in_unix,
		"clock_out_unix": clock_out_unix,
		"break_start_unix": break_start_unix,
		"break_end_unix": break_end_unix
	}

static func from_dict(data: Dictionary) -> Shift:
	var s := Shift.new()
	s.id = data.get("id", "")
	s.employee_id = data.get("employee_id", "")
	s.clock_in_unix = int(data.get("clock_in_unix", 0))
	s.clock_out_unix = int(data.get("clock_out_unix", 0))
	s.break_start_unix = int(data.get("break_start_unix", 0))
	s.break_end_unix = int(data.get("break_end_unix", 0))
	return s
