extends RefCounted
class_name JobTicket

const STATUSES := ["Draft", "Scheduled", "In Progress", "On Hold", "Completed", "Cancelled"]

var id: String = ""
var title: String = ""
var description: String = ""
var property_location: String = ""
var assigned_employee_ids: PackedStringArray = []
var priority: String = "Medium"
var status: String = "Draft"
var due_date_unix: int = 0
var created_date_unix: int = 0
var notes: String = ""
var photo_paths: PackedStringArray = []

func is_open() -> bool:
	return status in ["Draft", "Scheduled", "In Progress", "On Hold"]

func to_dict() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"description": description,
		"property_location": property_location,
		"assigned_employee_ids": assigned_employee_ids,
		"priority": priority,
		"status": status,
		"due_date_unix": due_date_unix,
		"created_date_unix": created_date_unix,
		"notes": notes,
		"photo_paths": photo_paths
	}

static func from_dict(data: Dictionary) -> JobTicket:
	var j := JobTicket.new()
	j.id = data.get("id", "")
	j.title = data.get("title", "")
	j.description = data.get("description", "")
	j.property_location = data.get("property_location", "")
	j.assigned_employee_ids = PackedStringArray(data.get("assigned_employee_ids", []))
	j.priority = data.get("priority", "Medium")
	j.status = data.get("status", "Draft")
	j.due_date_unix = int(data.get("due_date_unix", 0))
	j.created_date_unix = int(data.get("created_date_unix", 0))
	j.notes = data.get("notes", "")
	j.photo_paths = PackedStringArray(data.get("photo_paths", []))
	return j
