extends Control
class_name ScreenBase

func _clear(container: Node) -> void:
	for child in container.get_children():
		child.queue_free()

func _fmt_time(unix_time: int) -> String:
	if unix_time <= 0:
		return "-"
	return Time.get_datetime_string_from_unix_time(unix_time, true)
