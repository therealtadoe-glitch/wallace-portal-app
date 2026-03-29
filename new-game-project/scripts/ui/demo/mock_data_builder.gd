extends RefCounted
class_name MockDataBuilder

static func build_sample_app_data() -> AppDataRoot:
	var data := AppDataRoot.new()

	var role := RoleData.new()
	role.name = "Crew Lead"
	data.add_role(role)

	for i in 3:
		var employee := EmployeeData.new()
		employee.first_name = "Employee"
		employee.last_name = str(i + 1)
		employee.email = "employee%d@example.com" % (i + 1)
		employee.phone = "555-010%d" % i
		employee.role_id = role.role_id
		employee.pay_rate = 20.0 + i
		data.add_employee(employee)

	for i in 4:
		var inv := InventoryItemData.new()
		inv.name = "Item %d" % (i + 1)
		inv.category = "Supplies"
		inv.quantity = 10 + i
		inv.unit = "pcs"
		inv.sku = "SKU-%03d" % i
		inv.vendor = "Acme"
		data.add_inventory(inv)

	for i in 2:
		var equip := EquipmentItemData.new()
		equip.name = "Mower %d" % (i + 1)
		equip.equipment_type = "Mower"
		equip.serial_number = "MWR-%d" % (1000 + i)
		equip.assigned_employee_id = data.employees[i].employee_id
		equip.checked_out = true
		data.add_equipment(equip)

	for i in 3:
		var job := JobTicketData.new()
		job.title = "Job %d" % (i + 1)
		job.description = "Routine maintenance"
		job.village = "Springfield"
		job.street = "%d Main St" % (10 + i)
		job.assigned_employee_ids.append(data.employees[i % data.employees.size()].employee_id)
		job.status = AppEnums.JobStatus.SCHEDULED if i < 2 else AppEnums.JobStatus.COMPLETED
		data.add_job(job)

	for employee in data.employees:
		var card := TimecardData.new()
		card.employee_id = employee.employee_id
		card.clock_in_unix = Time.get_unix_time_from_system() - 3600
		card.clock_out_unix = Time.get_unix_time_from_system()
		card.break_minutes = 15
		data.add_timecard(card)

	return data
