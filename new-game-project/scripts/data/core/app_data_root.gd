extends Resource
class_name AppDataRoot

@export var employees: Array[EmployeeData] = []
@export var roles: Array[RoleData] = []
@export var inventory_items: Array[InventoryItemData] = []
@export var equipment_items: Array[EquipmentItemData] = []
@export var equipment_logs: Array[EquipmentLogEntryData] = []
@export var timecards: Array[TimecardData] = []
@export var jobs: Array[JobTicketData] = []

func get_employee_by_id(employee_id: String) -> EmployeeData:
	for item in employees:
		if item.employee_id == employee_id:
			return item
	return null

func get_role_by_id(role_id: String) -> RoleData:
	for item in roles:
		if item.role_id == role_id:
			return item
	return null

func get_inventory_by_id(item_id: String) -> InventoryItemData:
	for item in inventory_items:
		if item.item_id == item_id:
			return item
	return null

func get_equipment_by_id(equipment_id: String) -> EquipmentItemData:
	for item in equipment_items:
		if item.equipment_id == equipment_id:
			return item
	return null

func get_job_by_id(job_id: String) -> JobTicketData:
	for item in jobs:
		if item.job_id == job_id:
			return item
	return null

func add_employee(employee: EmployeeData) -> bool:
	if employee == null or not employee.is_valid() or get_employee_by_id(employee.employee_id) != null:
		return false
	employees.append(employee)
	return true

func update_employee(employee: EmployeeData) -> bool:
	if employee == null or not employee.is_valid():
		return false
	for i in employees.size():
		if employees[i].employee_id == employee.employee_id:
			employees[i] = employee
			return true
	return false

func remove_employee(employee_id: String) -> bool:
	for i in employees.size():
		if employees[i].employee_id == employee_id:
			employees.remove_at(i)
			return true
	return false

func add_role(role: RoleData) -> bool:
	if role == null or not role.is_valid() or get_role_by_id(role.role_id) != null:
		return false
	roles.append(role)
	return true

func add_inventory(item: InventoryItemData) -> bool:
	if item == null or not item.is_valid() or get_inventory_by_id(item.item_id) != null:
		return false
	inventory_items.append(item)
	return true

func add_equipment(item: EquipmentItemData) -> bool:
	if item == null or not item.is_valid() or get_equipment_by_id(item.equipment_id) != null:
		return false
	equipment_items.append(item)
	return true

func add_equipment_log(entry: EquipmentLogEntryData) -> bool:
	if entry == null or not entry.is_valid():
		return false
	equipment_logs.append(entry)
	return true

func add_timecard(card: TimecardData) -> bool:
	if card == null or not card.is_valid():
		return false
	timecards.append(card)
	return true

func add_job(job: JobTicketData) -> bool:
	if job == null or not job.is_valid() or get_job_by_id(job.job_id) != null:
		return false
	jobs.append(job)
	return true

func to_dict() -> Dictionary:
	var out := {
		"employees": [],
		"roles": [],
		"inventory_items": [],
		"equipment_items": [],
		"equipment_logs": [],
		"timecards": [],
		"jobs": []
	}
	for item in employees: out["employees"].append(item.to_dict())
	for item in roles: out["roles"].append(item.to_dict())
	for item in inventory_items: out["inventory_items"].append(item.to_dict())
	for item in equipment_items: out["equipment_items"].append(item.to_dict())
	for item in equipment_logs: out["equipment_logs"].append(item.to_dict())
	for item in timecards: out["timecards"].append(item.to_dict())
	for item in jobs: out["jobs"].append(item.to_dict())
	return out

func from_dict(data: Dictionary) -> void:
	employees.clear()
	roles.clear()
	inventory_items.clear()
	equipment_items.clear()
	equipment_logs.clear()
	timecards.clear()
	jobs.clear()

	for row in data.get("employees", []):
		var item := EmployeeData.new()
		item.from_dict(row)
		employees.append(item)
	for row in data.get("roles", []):
		var item := RoleData.new()
		item.from_dict(row)
		roles.append(item)
	for row in data.get("inventory_items", []):
		var item := InventoryItemData.new()
		item.from_dict(row)
		inventory_items.append(item)
	for row in data.get("equipment_items", []):
		var item := EquipmentItemData.new()
		item.from_dict(row)
		equipment_items.append(item)
	for row in data.get("equipment_logs", []):
		var item := EquipmentLogEntryData.new()
		item.from_dict(row)
		equipment_logs.append(item)
	for row in data.get("timecards", []):
		var item := TimecardData.new()
		item.from_dict(row)
		timecards.append(item)
	for row in data.get("jobs", []):
		var item := JobTicketData.new()
		item.from_dict(row)
		jobs.append(item)
