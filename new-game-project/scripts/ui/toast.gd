extends PanelContainer
class_name Toast

@onready var _label: Label = %ToastLabel
@onready var _timer: Timer = %HideTimer

func show_message(message: String, duration: float = 2.0) -> void:
	_label.text = message
	visible = true
	modulate.a = 1.0
	_timer.start(duration)

func _on_hide_timer_timeout() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.finished.connect(func(): visible = false)
