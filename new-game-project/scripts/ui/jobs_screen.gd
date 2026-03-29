extends ScreenBase

@onready var _list: RichTextLabel = %JobsLabel
@onready var _title: LineEdit = %TitleInput
@onready var _desc: TextEdit = %DescInput
@onready var _loc: LineEdit = %LocationInput
@onready var _status: OptionButton = %StatusInput
@onready var _priority: OptionButton = %PriorityInput
@onready var _filter: OptionButton = %FilterInput

func _ready() -> void:
	for s in JobTicket.STATUSES: _status.add_item(s)
	for p in ["Low", "Medium", "High", "Critical"]: _priority.add_item(p)
	_filter.add_item("All")
	for s in JobTicket.STATUSES: _filter.add_item(s)
	AppStore.data_changed.connect(_render)
	_render()

func _render() -> void:
	var current_filter := _filter.get_item_text(_filter.selected) if _filter.item_count > 0 else "All"
	var lines: PackedStringArray = []
	for j in AppStore.state.jobs:
		if current_filter != "All" and j.status != current_filter:
			continue
		lines.append("[%s] %s (%s) due %s" % [j.status, j.title, j.priority, _fmt_time(j.due_date_unix)])
	_list.text = "\n".join(lines)

func _on_create_pressed() -> void:
	var j := JobTicket.new()
	j.title = _title.text
	j.description = _desc.text
	j.property_location = _loc.text
	j.status = _status.get_item_text(_status.selected)
	j.priority = _priority.get_item_text(_priority.selected)
	j.due_date_unix = int(Time.get_unix_time_from_system()) + 86400
	var err := AppStore.upsert_job(j)
	if err == "":
		_title.text = ""; _desc.text = ""; _loc.text = ""
	else:
		AppStore.toast_requested.emit(err)

func _on_filter_item_selected(_index: int) -> void:
	_render()
