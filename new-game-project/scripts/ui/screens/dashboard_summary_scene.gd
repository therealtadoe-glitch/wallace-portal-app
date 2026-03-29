extends PanelContainer
class_name DashboardSummaryScene

var _built: bool = false
var _header: SectionHeader
var _grid: GridContainer
var _cards: Dictionary = {}
var _app_data: AppDataRoot

func _ready() -> void:
	_build_if_needed()
	refresh()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 8)
	margin.add_child(root)

	_header = SectionHeader.new()
	_header.set_title("Dashboard")
	root.add_child(_header)

	_grid = GridContainer.new()
	_grid.columns = 3
	_grid.add_theme_constant_override("h_separation", 8)
	_grid.add_theme_constant_override("v_separation", 8)
	root.add_child(_grid)

	_add_card("total_employees", "Total Employees")
	_add_card("active_employees", "Active Employees")
	_add_card("total_inventory", "Inventory Items")
	_add_card("checked_out_equipment", "Checked Out Equipment")
	_add_card("open_jobs", "Open Jobs")
	_add_card("today_timecards", "Today's Timecards")

func _add_card(key: String, title: String) -> void:
	var card := StatCard.new()
	card.set_stat(title, "0")
	_cards[key] = card
	_grid.add_child(card)

func set_app_data(app_data: AppDataRoot) -> void:
	_app_data = app_data
	refresh()

func refresh() -> void:
	_build_if_needed()
	if _app_data == null:
		return
	var today_start := Time.get_unix_time_from_datetime_dict(Time.get_date_dict_from_system())
	var active_count := 0
	for employee in _app_data.employees:
		if employee.is_active():
			active_count += 1
	var checked_out := 0
	for item in _app_data.equipment_items:
		if item.checked_out:
			checked_out += 1
	var open_jobs := 0
	for job in _app_data.jobs:
		if job.is_open():
			open_jobs += 1
	var today_cards := 0
	for card in _app_data.timecards:
		if card.clock_in_unix >= today_start:
			today_cards += 1

	(_cards["total_employees"] as StatCard).set_stat("Total Employees", str(_app_data.employees.size()))
	(_cards["active_employees"] as StatCard).set_stat("Active Employees", str(active_count))
	(_cards["total_inventory"] as StatCard).set_stat("Inventory Items", str(_app_data.inventory_items.size()))
	(_cards["checked_out_equipment"] as StatCard).set_stat("Checked Out Equipment", str(checked_out))
	(_cards["open_jobs"] as StatCard).set_stat("Open Jobs", str(open_jobs))
	(_cards["today_timecards"] as StatCard).set_stat("Today's Timecards", str(today_cards))
