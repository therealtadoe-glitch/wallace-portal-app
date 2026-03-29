extends Node
class_name PersistenceService

const SAVE_FILE := "user://landscape_portal_data.json"

func load_state() -> AppState:
	if not FileAccess.file_exists(SAVE_FILE):
		return AppState.new()
	var file := FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		return AppState.new()
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return AppState.new()
	return AppState.from_dict(parsed)

func save_state(state: AppState) -> bool:
	var file := FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(state.to_dict(), "\t"))
	return true
