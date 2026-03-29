extends PanelContainer
class_name JobTicketDetailScene

var _built: bool = false
var _header: SectionHeader
var _details: VBoxContainer
var _assigned_box: VBoxContainer
var _notes_box: VBoxContainer
var _job: JobTicketData
var _employee_name_by_id: Dictionary = {}

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
	_header.set_title("Job Detail")
	root.add_child(_header)

	_details = VBoxContainer.new()
	root.add_child(_details)

	var assigned_header := SectionHeader.new()
	assigned_header.set_title("Assigned Employees")
	root.add_child(assigned_header)
	_assigned_box = VBoxContainer.new()
	root.add_child(_assigned_box)

	var notes_header := SectionHeader.new()
	notes_header.set_title("Notes")
	root.add_child(notes_header)
	_notes_box = VBoxContainer.new()
	root.add_child(_notes_box)

func set_job(job: JobTicketData, employees: Array[EmployeeData] = []) -> void:
	_job = job
	_employee_name_by_id.clear()
	for employee in employees:
		_employee_name_by_id[employee.employee_id] = employee.get_full_name()
	refresh()

func refresh() -> void:
	_build_if_needed()
	_clear(_details)
	_clear(_assigned_box)
	_clear(_notes_box)
	if _job == null:
		_header.set_subtitle("No job selected")
		return

	_header.set_title(_job.title)
	_header.set_subtitle(AppEnums.display_name("JobStatus", _job.status))
	_add_detail("Description", _job.description)
	_add_detail("Location", "%s, %s %s" % [_job.street, _job.village, _job.unit])
	_add_detail("Priority", AppEnums.display_name("Priority", _job.priority))
	_add_detail("Work Type", AppEnums.display_name("WorkType", _job.work_type))
	_add_detail("Scheduled", str(_job.scheduled_date_unix))
	_add_detail("Completed", str(_job.completed_at_unix))

	if _job.assigned_employee_ids.is_empty():
		_add_row(_assigned_box, "", "No assignees")
	else:
		for employee_id in _job.assigned_employee_ids:
			_add_row(_assigned_box, "Employee", str(_employee_name_by_id.get(employee_id, employee_id)))

	if _job.notes.is_empty():
		_add_row(_notes_box, "", "No notes")
	else:
		for note in _job.notes:
			_add_row(_notes_box, note.note_id, note.text if not note.text.is_empty() else note.attachment_path)

func _add_detail(label_text: String, value_text: String) -> void:
	_add_row(_details, label_text, value_text)

func _add_row(parent: VBoxContainer, label_text: String, value_text: String) -> void:
	var row := LabeledValueRow.new()
	row.set_values(label_text, value_text)
	parent.add_child(row)

func _clear(parent: VBoxContainer) -> void:
	for child in parent.get_children():
		child.queue_free()
