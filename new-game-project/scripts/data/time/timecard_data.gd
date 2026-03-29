extends BaseDataResource
class_name TimecardData

@export var timecard_id: String = ""
@export var employee_id: String = ""
@export var clock_in_unix: int = 0
@export var clock_out_unix: int = 0
@export var break_minutes: int = 0
@export var related_job_id: String = ""
@export_multiline var notes: String = ""

func _init() -> void:
	ensure_timecard_id()

func ensure_timecard_id() -> String:
	if timecard_id.is_empty():
		timecard_id = IdGenerator.make_id("time")
		id = timecard_id
	return timecard_id

func get_total_hours() -> float:
	if clock_out_unix <= clock_in_unix:
		return 0.0
	var worked_seconds := clock_out_unix - clock_in_unix - (break_minutes * 60)
	if worked_seconds < 0:
		worked_seconds = 0
	return float(worked_seconds) / 3600.0

func is_open() -> bool:
	return clock_in_unix > 0 and clock_out_unix <= 0

func is_valid() -> bool:
	if employee_id.is_empty() or timecard_id.is_empty():
		return false
	if clock_in_unix <= 0:
		return false
	if clock_out_unix > 0 and clock_out_unix < clock_in_unix:
		return false
	return break_minutes >= 0

func to_dict() -> Dictionary:
	var data := super.to_dict()
	data.merge({
		"timecard_id": timecard_id,
		"employee_id": employee_id,
		"clock_in_unix": clock_in_unix,
		"clock_out_unix": clock_out_unix,
		"break_minutes": break_minutes,
		"related_job_id": related_job_id,
		"notes": notes
	}, true)
	return data

func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	timecard_id = str(data.get("timecard_id", ""))
	employee_id = str(data.get("employee_id", ""))
	clock_in_unix = int(data.get("clock_in_unix", 0))
	clock_out_unix = int(data.get("clock_out_unix", 0))
	break_minutes = int(data.get("break_minutes", 0))
	related_job_id = str(data.get("related_job_id", ""))
	notes = str(data.get("notes", ""))
