extends Node

# ----------------------------
# 1) Simple presets (use these)
# ----------------------------
enum Style {
	CLOCK_24,
	CLOCK_12,
	DATE_NUMERIC,
	DATE_SHORT,
	DATE_LONG,
	DATETIME_SHORT,
	DATETIME_LONG,
	FILESTAMP
}

const STYLE_PATTERN := {
	Style.CLOCK_24:      "{HH}:{mm}:{ss}",
	Style.CLOCK_12:      "{hh}:{mm}:{ss} {A}",
	Style.DATE_NUMERIC:  "{YYYY}-{MM}-{DD}",
	Style.DATE_SHORT:    "{MMM} {D}, {YYYY}",
	Style.DATE_LONG:     "{MMMM} {D}, {YYYY}",
	Style.DATETIME_SHORT:"{MMM} {D}, {YYYY}  {HH}:{mm}",
	Style.DATETIME_LONG: "{dddd}, {MMMM} {Do}, {YYYY}  —  {hh}:{mm} {A}",
	Style.FILESTAMP:     "{YYYY}-{MM}-{DD}_{HH}-{mm}-{ss}",
}

# ----------------------------
# 2) “Bind Label” system (no process code needed in your scenes)
# ----------------------------
var _bindings: Array[Dictionary] = []

func _ready() -> void:
	set_process(false)

func bind_label(
	label: Label,
	style: int = Style.CLOCK_24,
	update_every_seconds: float = 1.0,
	utc: bool = false
) -> void:
	if label == null:
		return

	# Remove existing binding for this label (avoid duplicates)
	unbind_label(label)

	_bindings.append({
		"ref": weakref(label),
		"style": style,
		"every": max(0.05, update_every_seconds),
		"accum": 0.0,
		"utc": utc,
	})

	# Set immediately
	_update_one(label, style, utc)

	# Start processing if needed
	set_process(true)

func unbind_label(label: Label) -> void:
	for i in range(_bindings.size() - 1, -1, -1):
		var ref = _bindings[i].ref.get_ref()
		if ref == null or ref == label:
			_bindings.remove_at(i)

	if _bindings.is_empty():
		set_process(false)

func bind(_owner: Node, label_path: NodePath, style: int = Style.CLOCK_24, update_every_seconds: float = 1.0, utc: bool = false) -> void:
	# Convenience: DateTime.bind(self, ^"HUD/ClockLabel", DateTime.Style.CLOCK_12)
	if _owner == null:
		return
	var n := _owner.get_node_or_null(label_path)
	if n is Label:
		bind_label(n, style, update_every_seconds, utc)

func _process(delta: float) -> void:
	for i in range(_bindings.size() - 1, -1, -1):
		var b := _bindings[i]
		var label: Label = b.ref.get_ref()
		if label == null:
			_bindings.remove_at(i)
			continue

		b.accum += delta
		if b.accum >= b.every:
			b.accum = fmod(b.accum, b.every)
			_update_one(label, b.style, b.utc)

		_bindings[i] = b

	if _bindings.is_empty():
		set_process(false)

# ----------------------------
# 3) Super simple formatting API
# ----------------------------
func text_now(style: int = Style.DATETIME_LONG, utc: bool = false) -> String:
	return format_dict(Time.get_datetime_dict_from_system(utc), STYLE_PATTERN.get(style, "{YYYY}-{MM}-{DD} {HH}:{mm}:{ss}"))

func set_text(label: Label, style: int = Style.DATETIME_LONG, utc: bool = false) -> void:
	if label:
		label.text = text_now(style, utc)

# If you ever want a custom look later, you CAN use this (optional).
# Example: DateTime.custom_now("{MMMM} {D} @ {hh}:{mm} {A}")
func custom_now(pattern: String, utc: bool = false) -> String:
	return format_dict(Time.get_datetime_dict_from_system(utc), pattern)

# ----------------------------
# 4) Internal: token formatter (you don't need to touch this)
# ----------------------------
func _update_one(label: Label, style: int, utc: bool) -> void:
	var dt := Time.get_datetime_dict_from_system(utc)
	var pattern = STYLE_PATTERN.get(style, "{YYYY}-{MM}-{DD} {HH}:{mm}:{ss}")
	label.text = format_dict(dt, pattern)

func format_dict(dt: Dictionary, pattern: String) -> String:
	# Supported tokens used by presets:
	# {YYYY} {MM} {DD} {D} {MMM} {MMMM} {Do}
	# {HH} {hh} {mm} {ss} {A}
	# {ddd} {dddd}
	var out := pattern

	out = out.replace("{YYYY}", str(dt.year))
	out = out.replace("{MM}", _pad2(dt.month))
	out = out.replace("{DD}", _pad2(dt.day))
	out = out.replace("{D}", str(dt.day))

	out = out.replace("{HH}", _pad2(dt.hour))
	out = out.replace("{mm}", _pad2(dt.minute))
	out = out.replace("{ss}", _pad2(dt.second))

	var h12 := _hour_12(dt.hour)
	out = out.replace("{hh}", _pad2(h12))
	out = out.replace("{A}", "AM" if dt.hour < 12 else "PM")

	out = out.replace("{MMM}", _month_short(dt.month))
	out = out.replace("{MMMM}", _month_full(dt.month))
	out = out.replace("{Do}", _ordinal(dt.day))

	# Godot weekday: Sunday=0 ... Saturday=6
	out = out.replace("{ddd}", _weekday_short(int(dt.weekday)))
	out = out.replace("{dddd}", _weekday_full(int(dt.weekday)))

	return out

func _pad2(n: int) -> String:
	return "%02d" % n

func _hour_12(h24: int) -> int:
	var h := h24 % 12
	return 12 if h == 0 else h

func _ordinal(n: int) -> String:
	var mod100 := n % 100
	if mod100 >= 11 and mod100 <= 13:
		return "%dth" % n
	match n % 10:
		1: return "%dst" % n
		2: return "%dnd" % n
		3: return "%drd" % n
		_: return "%dth" % n

func _month_short(m: int) -> String:
	var months := ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
	return months[clamp(m - 1, 0, 11)]

func _month_full(m: int) -> String:
	var months := ["January","February","March","April","May","June","July","August","September","October","November","December"]
	return months[clamp(m - 1, 0, 11)]

func _weekday_short(w: int) -> String:
	var days := ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
	return days[clamp(w, 0, 6)]

func _weekday_full(w: int) -> String:
	var days := ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
	return days[clamp(w, 0, 6)]
