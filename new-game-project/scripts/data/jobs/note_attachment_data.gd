extends BaseDataResource
class_name NoteAttachmentData

@export var note_id: String = ""
@export var text: String = ""
@export var attachment_path: String = ""
@export var mime_type: String = ""
@export var created_by_employee_id: String = ""
@export var created_at_unix_override: int = 0

func _init() -> void:
	ensure_note_id()

func ensure_note_id() -> String:
	if note_id.is_empty():
		note_id = IdGenerator.make_id("note")
		id = note_id
	return note_id

func get_created_at() -> int:
	if created_at_unix_override > 0:
		return created_at_unix_override
	return created_at_unix

func is_valid() -> bool:
	return ValidationUtils.is_non_empty(note_id) and (ValidationUtils.is_non_empty(text) or ValidationUtils.is_non_empty(attachment_path))

func to_dict() -> Dictionary:
	var data := super.to_dict()
	data.merge({
		"note_id": note_id,
		"text": text,
		"attachment_path": attachment_path,
		"mime_type": mime_type,
		"created_by_employee_id": created_by_employee_id,
		"created_at_unix_override": created_at_unix_override
	}, true)
	return data

func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	note_id = str(data.get("note_id", ""))
	text = str(data.get("text", ""))
	attachment_path = str(data.get("attachment_path", ""))
	mime_type = str(data.get("mime_type", ""))
	created_by_employee_id = str(data.get("created_by_employee_id", ""))
	created_at_unix_override = int(data.get("created_at_unix_override", 0))
