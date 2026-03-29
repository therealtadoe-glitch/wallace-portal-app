extends Control

const SCREEN_SCENES := {
	"Dashboard": "res://scenes/screens/dashboard_screen.tscn",
	"Employees": "res://scenes/screens/employees_screen.tscn",
	"Time": "res://scenes/screens/time_screen.tscn",
	"Inventory": "res://scenes/screens/inventory_screen.tscn",
	"Equipment": "res://scenes/screens/equipment_screen.tscn",
	"Jobs": "res://scenes/screens/jobs_screen.tscn"
}

@onready var _content: VBoxContainer = %Content
@onready var _toast: Toast = %Toast

var _current_screen: Control

func _ready() -> void:
	AppStore.toast_requested.connect(_on_toast)
	_show_screen("Dashboard")

func _on_tab_pressed(tab_name: String) -> void:
	_show_screen(tab_name)

func _show_screen(tab_name: String) -> void:
	if _current_screen != null:
		_current_screen.queue_free()
	var scene: PackedScene = load(SCREEN_SCENES[tab_name])
	_current_screen = scene.instantiate()
	_content.add_child(_current_screen)

func _on_toast(message: String) -> void:
	_toast.show_message(message)
