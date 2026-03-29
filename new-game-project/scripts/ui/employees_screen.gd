extends ScreenBase

@onready var _list: ItemList = %EmployeeList
@onready var _name: LineEdit = %NameInput
@onready var _phone: LineEdit = %PhoneInput
@onready var _email: LineEdit = %EmailInput
@onready var _role: LineEdit = %RoleInput
@onready var _dept: LineEdit = %DeptInput
@onready var _pay: SpinBox = %PayInput
@onready var _notes: TextEdit = %NotesInput
@onready var _search: LineEdit = %SearchInput

func _ready() -> void:
	AppStore.data_changed.connect(_render)
	_render()

func _render() -> void:
	_list.clear()
	var query := _search.text.to_lower()
	for e in AppStore.state.employees:
		if query != "" and not e.full_name.to_lower().contains(query):
			continue
		_list.add_item("%s • %s • $%.2f" % [e.full_name, e.role, e.hourly_pay])

func _on_add_pressed() -> void:
	var e := Employee.new()
	e.full_name = _name.text
	e.phone = _phone.text
	e.email = _email.text
	e.role = _role.text
	e.department = _dept.text
	e.hourly_pay = _pay.value
	e.notes = _notes.text
	var error := AppStore.upsert_employee(e)
	if error == "":
		_clear_form()
	else:
		AppStore.toast_requested.emit(error)

func _clear_form() -> void:
	_name.text = ""
	_phone.text = ""
	_email.text = ""
	_role.text = ""
	_dept.text = ""
	_pay.value = 0.0
	_notes.text = ""

func _on_search_text_changed(_new_text: String) -> void:
	_render()
