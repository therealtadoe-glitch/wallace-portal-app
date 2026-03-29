extends Control
class_name DemoScreen

var _built: bool = false
var _tabs: TabContainer

func _ready() -> void:
	_build_if_needed()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true

	var app_data := MockDataBuilder.build_sample_app_data()

	_tabs = TabContainer.new()
	_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(_tabs)

	var dashboard := DashboardSummaryScene.new()
	dashboard.set_app_data(app_data)
	dashboard.name = "Dashboard"
	_tabs.add_child(dashboard)

	var emp_list := EmployeeListScene.new()
	emp_list.set_employees(app_data.employees, app_data.roles)
	emp_list.name = "Employees"
	_tabs.add_child(emp_list)

	var inv_list := InventoryListScene.new()
	inv_list.set_items(app_data.inventory_items)
	inv_list.name = "Inventory"
	_tabs.add_child(inv_list)

	var equip_list := EquipmentListScene.new()
	equip_list.set_equipment(app_data.equipment_items, app_data.employees)
	equip_list.name = "Equipment"
	_tabs.add_child(equip_list)

	var job_list := JobTicketListScene.new()
	job_list.set_jobs(app_data.jobs, app_data.employees)
	job_list.name = "Jobs"
	_tabs.add_child(job_list)

	var timecards := TimecardListScene.new()
	timecards.set_timecards(app_data.timecards, app_data.employees)
	timecards.name = "Timecards"
	_tabs.add_child(timecards)
