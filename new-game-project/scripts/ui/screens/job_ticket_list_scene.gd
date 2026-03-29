extends PanelContainer
class_name JobTicketListScene

var _built: bool = false
var _header: SectionHeader
var _filter_bar: SearchFilterBar
var _scroll: ScrollContainer
var _list_root: VBoxContainer
var _empty_state: EmptyStateView
var _jobs: Array[JobTicketData] = []
var _employee_name_by_id: Dictionary = {}
var _search_text: String = ""

func _ready() -> void:
	_build_if_needed()
	_wire()
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
	_header.set_title("Jobs")
	root.add_child(_header)

	_filter_bar = SearchFilterBar.new()
	_filter_bar.set_filter_options(PackedStringArray(["All", "Draft", "Scheduled", "In Progress", "On Hold", "Completed", "Cancelled"]))
	root.add_child(_filter_bar)

	_scroll = ScrollContainer.new()
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(_scroll)
	_list_root = VBoxContainer.new()
	_scroll.add_child(_list_root)

	_empty_state = EmptyStateView.new()
	_empty_state.set_content("No jobs", "No jobs match your search/filter.")
	root.add_child(_empty_state)

func _wire() -> void:
	if not _filter_bar.search_changed.is_connected(_on_search_changed):
		_filter_bar.search_changed.connect(_on_search_changed)

func set_jobs(jobs: Array[JobTicketData], employees: Array[EmployeeData] = []) -> void:
	_jobs = jobs.duplicate()
	_employee_name_by_id.clear()
	for employee in employees:
		_employee_name_by_id[employee.employee_id] = employee.get_full_name()
	refresh()

func refresh() -> void:
	_build_if_needed()
	clear_list()
	var count := 0
	for job in _jobs:
		if not _search_text.is_empty() and not (job.title + " " + job.description + " " + job.street + " " + job.village).to_lower().contains(_search_text):
			continue
		_list_root.add_child(create_job_row(job))
		count += 1
	_empty_state.visible = count == 0
	_scroll.visible = count > 0
	_header.set_subtitle("%d shown" % count)

func clear_list() -> void:
	for child in _list_root.get_children():
		child.queue_free()

func create_job_row(job: JobTicketData) -> JobRow:
	var summary := _assigned_summary(job)
	var row := JobRow.new()
	row.set_job(job, summary)
	return row

func _assigned_summary(job: JobTicketData) -> String:
	if job.assigned_employee_ids.is_empty():
		return "Unassigned"
	var names: PackedStringArray = []
	for employee_id in job.assigned_employee_ids:
		names.append(str(_employee_name_by_id.get(employee_id, employee_id)))
	return ", ".join(names)

func _on_search_changed(text: String) -> void:
	_search_text = text.strip_edges().to_lower()
	refresh()
