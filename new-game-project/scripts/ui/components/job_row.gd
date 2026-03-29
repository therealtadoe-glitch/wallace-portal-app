extends PanelContainer
class_name JobRow

var _built: bool = false
var _title_label: Label
var _status_label: Label
var _location_label: Label
var _meta_label: Label

func _ready() -> void:
	_build_if_needed()

func _build_if_needed() -> void:
	if _built:
		return
	_built = true
	custom_minimum_size = Vector2(0, 72)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 6)
	add_child(margin)

	var col := VBoxContainer.new()
	margin.add_child(col)

	var top := HBoxContainer.new()
	col.add_child(top)

	_title_label = Label.new()
	_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(_title_label)

	_status_label = Label.new()
	top.add_child(_status_label)

	_location_label = Label.new()
	col.add_child(_location_label)

	_meta_label = Label.new()
	_meta_label.modulate = Color(0.7, 0.7, 0.7)
	col.add_child(_meta_label)

func set_job(job: JobTicketData, assignee_summary: String) -> void:
	_build_if_needed()
	_title_label.text = job.title
	_status_label.text = AppEnums.display_name("JobStatus", job.status)
	_location_label.text = "%s, %s %s" % [job.street, job.village, job.unit]
	_meta_label.text = "%s | %s | Assigned: %s" % [AppEnums.display_name("Priority", job.priority), AppEnums.display_name("WorkType", job.work_type), assignee_summary]
