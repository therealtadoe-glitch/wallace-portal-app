extends Node
class_name AppStore

signal data_changed
signal toast_requested(message: String)

var state: AppState
var _persistence: PersistenceService

func _ready() -> void:
	_persistence = PersistenceService.new()
	add_child(_persistence)
	state = _persistence.load_state()
	if state.employees.is_empty():
		_seed_mock_data()
		save()

func save() -> void:
	_persistence.save_state(state)
	emit_signal("data_changed")

func upsert_employee(employee: Employee) -> String:
	var validation_message := Validation.require_text(employee.full_name, "Full Name")
	if validation_message != "":
		return validation_message
	if employee.email != "" and not Validation.is_valid_email(employee.email):
		return "Invalid email format."
	if employee.id == "":
		employee.id = AppIdGenerator.next("emp")
		employee.hire_date_unix = employee.hire_date_unix if employee.hire_date_unix > 0 else int(Time.get_unix_time_from_system())
		state.employees.append(employee)
	else:
		for i in state.employees.size():
			if state.employees[i].id == employee.id:
				state.employees[i] = employee
				break
	save()
	return ""

func upsert_inventory(item: InventoryItem) -> String:
	var message := Validation.require_text(item.item_name, "Item Name")
	if message != "":
		return message
	if item.id == "":
		item.id = AppIdGenerator.next("inv")
		state.inventory_items.append(item)
	else:
		for i in state.inventory_items.size():
			if state.inventory_items[i].id == item.id:
				state.inventory_items[i] = item
				break
	save()
	return ""

func upsert_job(job: JobTicket) -> String:
	var message := Validation.require_text(job.title, "Title")
	if message != "":
		return message
	if job.id == "":
		job.id = AppIdGenerator.next("job")
		job.created_date_unix = int(Time.get_unix_time_from_system())
		state.jobs.append(job)
	else:
		for i in state.jobs.size():
			if state.jobs[i].id == job.id:
				state.jobs[i] = job
				break
	save()
	return ""

func active_shift_for_employee(employee_id: String) -> Shift:
	for s in state.shifts:
		if s.employee_id == employee_id and s.is_open():
			return s
	return null

func clock_in(employee_id: String) -> void:
	if active_shift_for_employee(employee_id) != null:
		emit_signal("toast_requested", "Employee already clocked in.")
		return
	var shift := Shift.new()
	shift.id = AppIdGenerator.next("shift")
	shift.employee_id = employee_id
	shift.clock_in_unix = int(Time.get_unix_time_from_system())
	state.shifts.append(shift)
	save()
	emit_signal("toast_requested", "Clock in recorded.")

func clock_out(employee_id: String) -> void:
	var shift := active_shift_for_employee(employee_id)
	if shift == null:
		emit_signal("toast_requested", "No open shift found.")
		return
	shift.clock_out_unix = int(Time.get_unix_time_from_system())
	save()
	emit_signal("toast_requested", "Clock out recorded.")

func toggle_break(employee_id: String) -> void:
	var shift := active_shift_for_employee(employee_id)
	if shift == null:
		return
	if shift.break_start_unix == 0 or shift.break_end_unix > 0:
		shift.break_start_unix = int(Time.get_unix_time_from_system())
		shift.break_end_unix = 0
		emit_signal("toast_requested", "Break started.")
	else:
		shift.break_end_unix = int(Time.get_unix_time_from_system())
		emit_signal("toast_requested", "Break ended.")
	save()

func checkout_equipment(item_id: String, employee_id: String, expected_return_unix: int, condition_out: String, notes: String) -> void:
	var checkout := EquipmentCheckout.new()
	checkout.id = AppIdGenerator.next("co")
	checkout.inventory_item_id = item_id
	checkout.employee_id = employee_id
	checkout.checked_out_unix = int(Time.get_unix_time_from_system())
	checkout.expected_return_unix = expected_return_unix
	checkout.condition_out = condition_out
	checkout.notes = notes
	state.checkouts.append(checkout)
	save()

func checkin_equipment(checkout_id: String, condition_in: String) -> void:
	for co in state.checkouts:
		if co.id == checkout_id:
			co.actual_return_unix = int(Time.get_unix_time_from_system())
			co.condition_in = condition_in
			break
	save()

func _seed_mock_data() -> void:
	var e1 := Employee.new(); e1.id = AppIdGenerator.next("emp"); e1.full_name = "Ava Green"; e1.role = "Crew Lead"; e1.department = "Maintenance"; e1.hourly_pay = 28.5; e1.phone = "555-0101"; e1.email = "ava@landscape.local"; e1.hire_date_unix = int(Time.get_unix_time_from_system()) - 86400 * 300
	var e2 := Employee.new(); e2.id = AppIdGenerator.next("emp"); e2.full_name = "Liam Stone"; e2.role = "Technician"; e2.department = "Install"; e2.hourly_pay = 22.0; e2.phone = "555-0102"; e2.email = "liam@landscape.local"; e2.hire_date_unix = int(Time.get_unix_time_from_system()) - 86400 * 120
	state.employees.append_array([e1, e2])

	var inv1 := InventoryItem.new(); inv1.id = AppIdGenerator.next("inv"); inv1.item_name = "String Trimmer"; inv1.category = "Tools"; inv1.quantity = 4; inv1.minimum_quantity = 2; inv1.condition = "Good"
	var inv2 := InventoryItem.new(); inv2.id = AppIdGenerator.next("inv"); inv2.item_name = "Fertilizer NPK 20-10-10"; inv2.category = "Chemicals"; inv2.quantity = 2; inv2.minimum_quantity = 3; inv2.condition = "Good"
	state.inventory_items.append_array([inv1, inv2])

	var job := JobTicket.new(); job.id = AppIdGenerator.next("job"); job.title = "Spring Mulch Refresh"; job.description = "Replace mulch and edge beds."; job.property_location = "114 Sunset Dr"; job.status = "Scheduled"; job.priority = "High"; job.assigned_employee_ids = [e1.id, e2.id]; job.created_date_unix = int(Time.get_unix_time_from_system()); job.due_date_unix = int(Time.get_unix_time_from_system()) + 86400 * 2
	state.jobs.append(job)
