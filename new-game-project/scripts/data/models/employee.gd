extends RefCounted
class_name Employee

var id: String = ""
var full_name: String = ""
var phone: String = ""
var email: String = ""
var role: String = ""
var department: String = ""
var hourly_pay: float = 0.0
var active: bool = true
var profile_photo_path: String = ""
var hire_date_unix: int = 0
var notes: String = ""

func to_dict() -> Dictionary:
	return {
		"id": id,
		"full_name": full_name,
		"phone": phone,
		"email": email,
		"role": role,
		"department": department,
		"hourly_pay": hourly_pay,
		"active": active,
		"profile_photo_path": profile_photo_path,
		"hire_date_unix": hire_date_unix,
		"notes": notes
	}

static func from_dict(data: Dictionary) -> Employee:
	var e := Employee.new()
	e.id = data.get("id", "")
	e.full_name = data.get("full_name", "")
	e.phone = data.get("phone", "")
	e.email = data.get("email", "")
	e.role = data.get("role", "")
	e.department = data.get("department", "")
	e.hourly_pay = float(data.get("hourly_pay", 0.0))
	e.active = bool(data.get("active", true))
	e.profile_photo_path = data.get("profile_photo_path", "")
	e.hire_date_unix = int(data.get("hire_date_unix", 0))
	e.notes = data.get("notes", "")
	return e
