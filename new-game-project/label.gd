extends Label

@onready var timer: Timer = Timer.new()


func _ready() -> void:
	print("SYSTEM: ", Time.get_datetime_dict_from_system(true))
	print("UNIX NOW: ", DateTime.now_unix())
	print("FORMAT NOW: ", DateTime.format_now(DateTime.Preset.TIME_12H))
	print("FORMAT UNIX NOW: ", DateTime.format_unix(DateTime.now_unix(), DateTime.Preset.TIME_12H))
	text = str(DateTime.format_now(DateTime.Preset.DATETIME_SHORT_12H))
	print(text)
