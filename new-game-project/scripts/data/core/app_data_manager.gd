extends Node
class_name AppDataManager

const SAVE_PATH := "user://app_data.json"

@export var app_data: AppDataRoot = AppDataRoot.new()

func _ready() -> void:
	if app_data == null:
		app_data = AppDataRoot.new()

func new_blank_data() -> void:
	app_data = AppDataRoot.new()

func save_to_disk(path: String = SAVE_PATH) -> Error:
	return ResourceSerializer.save_resource_json(path, app_data)

func load_from_disk(path: String = SAVE_PATH) -> bool:
	var raw := ResourceSerializer.load_json_to_dict(path)
	if raw.is_empty():
		return false
	var loaded := AppDataRoot.new()
	loaded.from_dict(raw)
	app_data = loaded
	return true

func seed_example_employee() -> EmployeeData:
	var employee := EmployeeData.new()
	employee.first_name = "Alex"
	employee.last_name = "Rivera"
	employee.email = "alex.rivera@example.com"
	employee.hire_date_unix = Time.get_unix_time_from_system()
	employee.pay_rate = 24.0
	app_data.add_employee(employee)
	return employee
