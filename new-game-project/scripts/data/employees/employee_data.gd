extends BaseDataResource
class_name EmployeeData

@export var employee_id: String = ""
@export var first_name: String = ""
@export var last_name: String = ""
@export var phone: String = ""
@export var email: String = ""
@export var role_id: String = ""
@export var status: AppEnums.EmployeeStatus = AppEnums.EmployeeStatus.ACTIVE
@export var hire_date_unix: int = 0
@export var pay_rate: float = 0.0
@export var tags: PackedStringArray = []
@export_multiline var notes: String = ""
@export_file("*.png,*.jpg,*.jpeg,*.webp") var profile_photo_path: String = ""

func _init() -> void:
	ensure_employee_id()

func ensure_employee_id() -> String:
	if employee_id.is_empty():
		employee_id = IdGenerator.make_id("emp")
		id = employee_id
	return employee_id

func get_full_name() -> String:
	return (first_name + " " + last_name).strip_edges()

func is_active() -> bool:
	return status == AppEnums.EmployeeStatus.ACTIVE

func is_valid() -> bool:
	return ValidationUtils.is_non_empty(employee_id) \
		and ValidationUtils.is_non_empty(first_name) \
		and ValidationUtils.is_non_empty(last_name) \
		and ValidationUtils.is_valid_email(email) \
		and ValidationUtils.is_non_negative(pay_rate)

func to_dict() -> Dictionary:
	var data := super.to_dict()
	data.merge({
		"employee_id": employee_id,
		"first_name": first_name,
		"last_name": last_name,
		"phone": phone,
		"email": email,
		"role_id": role_id,
		"status": status,
		"hire_date_unix": hire_date_unix,
		"pay_rate": pay_rate,
		"tags": tags,
		"notes": notes,
		"profile_photo_path": profile_photo_path
	}, true)
	return data

func from_dict(data: Dictionary) -> void:
	super.from_dict(data)
	employee_id = str(data.get("employee_id", ""))
	first_name = str(data.get("first_name", ""))
	last_name = str(data.get("last_name", ""))
	phone = str(data.get("phone", ""))
	email = str(data.get("email", ""))
	role_id = str(data.get("role_id", ""))
	status = int(data.get("status", AppEnums.EmployeeStatus.ACTIVE))
	hire_date_unix = int(data.get("hire_date_unix", 0))
	pay_rate = float(data.get("pay_rate", 0.0))
	tags = PackedStringArray(data.get("tags", PackedStringArray()))
	notes = str(data.get("notes", ""))
	profile_photo_path = str(data.get("profile_photo_path", ""))
