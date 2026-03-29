extends ScreenBase

@onready var _stats: RichTextLabel = %Stats

func _ready() -> void:
	AppStore.data_changed.connect(_render)
	_render()

func _render() -> void:
	var clocked_in := 0
	for e in AppStore.state.employees:
		if AppStore.active_shift_for_employee(e.id) != null:
			clocked_in += 1
	var low_stock := 0
	for item in AppStore.state.inventory_items:
		if item.is_low_stock():
			low_stock += 1
	var checked_out := 0
	for c in AppStore.state.checkouts:
		if c.is_active():
			checked_out += 1
	var open_jobs := 0
	for j in AppStore.state.jobs:
		if j.is_open():
			open_jobs += 1
	_stats.text = "[b]Employees:[/b] %d\n[b]Clocked In:[/b] %d\n[b]Low Stock:[/b] %d\n[b]Equipment Out:[/b] %d\n[b]Open Jobs:[/b] %d" % [AppStore.state.employees.size(), clocked_in, low_stock, checked_out, open_jobs]
