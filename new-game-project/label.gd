extends Label

@onready var timer: Timer = Timer.new()


func _ready() -> void:
	timer.wait_time = 60.0
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_on_minute_tick)

	add_child(timer)

	# Run immediately too (optional)
	_on_minute_tick()


func _on_minute_tick() -> void:
	var time_text := DateTime.format_now("h:mm A")
	print(time_text)
