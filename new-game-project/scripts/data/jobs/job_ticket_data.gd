extends BaseDataResource
class_name JobTicketData

@export var job_id: String = ""
@export var title: String = ""
@export_multiline var description: String = ""
@export var customer_name: String = ""
@export var location_name: String = ""
@export var village: String = ""
@export var street: String = ""
@export var unit: String = ""
@export var assigned_employee_ids: PackedStringArray = []
@export var status: AppEnums.JobStatus = AppEnums.JobStatus.DRAFT
@export var priority: AppEnums.Priority = AppEnums.Priority.NORMAL
@export var work_type: AppEnums.WorkType = AppEnums.WorkType.OTHER
@export var scheduled_date_unix: int = 0
@export var completed_at_unix: int = 0
@export var notes: Array[NoteAttachmentData] = []

func _init() -> void:
	ensure_job_id()

func ensure_job_id() -> String:
	if job_id.is_empty():
		job_id = IdGenerator.make_id("job")
		id = job_id
	return job_id

func add_assignee(employee_id: String) -> bool:
	if employee_id.is_empty() or assigned_employee_ids.has(employee_id):
		return false
	assigned_employee_ids.append(employee_id)
	touch()
	return true

func remove_assignee(employee_id: String) -> bool:
	var idx := assigned_employee_ids.find(employee_id)
	if idx == -1:
		return false
	assigned_employee_ids.remove_at(idx)
	touch()
	return true

func add_note(note: NoteAttachmentData) -> bool:
	if note == null or not note.is_valid():
		return false
	notes.append(note)
	touch()
	return true

func mark_completed() -> void:
	status = AppEnums.JobStatus.COMPLETED
	completed_at_unix = Time.get_unix_time_from_system()
	touch()

func is_open() -> bool:
	return status in [AppEnums.JobStatus.SCHEDULED, AppEnums.JobStatus.IN_PROGRESS, AppEnums.JobStatus.ON_HOLD]

func is_valid() -> bool:
	return ValidationUtils.is_non_empty(job_id) and ValidationUtils.is_non_empty(title)

func to_dict() -> Dictionary:
	var note_dicts: Array = []
	for note in notes:
		note_dicts.append(note.to_dict())
	var data := super.to_dict()
	data.merge({
		"job_id": job_id,
		"title": title,
		"description": description,
		"customer_name": customer_name,
		"location_name": location_name,
		"village": village,
		"street": street,
		"unit": unit,
		"assigned_employee_ids": assigned_employee_ids,
		"status": status,
		"priority": priority,
		"work_type": work_type,
		"scheduled_date_unix": scheduled_date_unix,
		"completed_at_unix": completed_at_unix,
		"notes": note_dicts
	}, true)
	return data

func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	job_id = str(data.get("job_id", ""))
	title = str(data.get("title", ""))
	description = str(data.get("description", ""))
	customer_name = str(data.get("customer_name", ""))
	location_name = str(data.get("location_name", ""))
	village = str(data.get("village", ""))
	street = str(data.get("street", ""))
	unit = str(data.get("unit", ""))
	assigned_employee_ids = PackedStringArray(data.get("assigned_employee_ids", PackedStringArray()))
	status = int(data.get("status", AppEnums.JobStatus.DRAFT))
	priority = int(data.get("priority", AppEnums.Priority.NORMAL))
	work_type = int(data.get("work_type", AppEnums.WorkType.OTHER))
	scheduled_date_unix = int(data.get("scheduled_date_unix", 0))
	completed_at_unix = int(data.get("completed_at_unix", 0))
	notes.clear()
	for note_data in data.get("notes", []):
		var note := NoteAttachmentData.new()
		note.from_dict(note_data)
		notes.append(note)
