# DateTime (Godot Autoload)

A modular, flexible date/time formatting utility for Godot 4.x.

This singleton is designed to:
- Format Unix timestamps into readable strings
- Support custom formatting patterns
- Provide relative time labels like "5 minutes ago"
- Convert between Unix timestamps and datetime dictionaries
- Provide reusable preset enums for UI components
- Keep your app consistent and scalable

---

## 🚀 Setup

1. Place the script in your project:

`res://autoloads/DateTime.gd`

2. Add it as an autoload:

**Project Settings → Autoload**
- Name: `DateTime`
- Path: `res://autoloads/DateTime.gd`

3. Use it anywhere:

```gdscript
print(DateTime.format_now("YYYY-MM-DD"))
print(DateTime.format_now_preset(DateTime.FormatPreset.LONG_DATE))
```

---

## 🧠 Core Concept

Always store time as Unix timestamps.

`gdscript
var timestamp := DateTime.now_unix()
`

Then format it only when displaying:

`gdscript
var text := DateTime.format_unix(timestamp, "MMMM D, YYYY")
`

Or use presets:

`gdscript
var text := DateTime.format_unix_preset(timestamp, DateTime.FormatPreset.LONG_DATE)
`

This keeps your data clean and your UI flexible.

---

## ⏱️ Getting Time

### Get current Unix time

`gdscript
DateTime.now_unix()
# -> 1773885600
`

### Get current datetime dictionary

`gdscript
DateTime.now_dict()
# -> {
#      "year": 2026,
#      "month": 3,
#      "day": 18,
#      "hour": 20,
#      "minute": 14,
#      "second": 32
#    }
`

---

## 🎨 Formatting Dates & Times

### Format a Unix timestamp with a custom pattern

`gdscript
DateTime.format_unix(timestamp, "YYYY-MM-DD")
# -> "2026-03-18"
`

### Format the current time with a custom pattern

`gdscript
DateTime.format_now("h:mm A")
# -> "8:14 PM"
`

### Format using a datetime dictionary

`gdscript
DateTime.format_dict({
	"year": 2026,
	"month": 3,
	"day": 18
}, "MM/DD/YYYY")
# -> "03/18/2026"
`

---

## 🧩 Format Tokens

| Token | Output Example |
|------|----------------|
| YYYY | 2026 |
| YY   | 26 |
| MMMM | March |
| MMM  | Mar |
| MM   | 03 |
| M    | 3 |
| DD   | 08 |
| D    | 8 |
| Do   | 8th |
| dddd | Wednesday |
| ddd  | Wed |
| HH   | 20 |
| H    | 20 |
| hh   | 08 |
| h    | 8 |
| mm   | 05 |
| m    | 5 |
| ss   | 04 |
| s    | 4 |
| A    | PM |
| a    | pm |

---

## 🧱 Format Presets

The autoload includes an enum called `DateTime.FormatPreset` so you can reuse common formats without rewriting pattern strings.

Available presets:

- `SHORT_DATE`
- `LONG_DATE`
- `SHORT_TIME_12`
- `LONG_TIME_12`
- `SHORT_TIME_24`
- `LONG_TIME_24`
- `DATE_TIME_12`
- `DATE_TIME_24`
- `FULL_DATE_TIME_12`
- `FULL_DATE_TIME_24`
- `ISO_DATE`
- `ISO_TIME`
- `ISO_DATE_TIME`
- `WEEKDAY_SHORT`
- `WEEKDAY_LONG`
- `MONTH_DAY`
- `MONTH_DAY_YEAR`
- `RELATIVE`

### Get a pattern from a preset

```gdscript
DateTime.get_pattern(DateTime.FormatPreset.SHORT_DATE)
# -> "MM/DD/YYYY"
```

### Format a Unix timestamp using a preset

```gdscript
DateTime.format_unix_preset(timestamp, DateTime.FormatPreset.SHORT_DATE)
# -> "03/18/2026"

DateTime.format_unix_preset(timestamp, DateTime.FormatPreset.LONG_TIME_12)
# -> "8:14:32 PM"
```

### Format the current time using a preset

```gdscript
DateTime.format_now_preset(DateTime.FormatPreset.LONG_DATE)
# -> "Wednesday, March 18, 2026"
```

### Format a datetime dictionary using a preset

```gdscript
DateTime.format_dict_preset({
	"year": 2026,
	"month": 3,
	"day": 18
}, DateTime.FormatPreset.MONTH_DAY_YEAR)
# -> "March 18, 2026"
```

### About the `RELATIVE` preset

`RELATIVE` is best used for existing timestamps:

```gdscript
DateTime.format_unix_preset(last_saved_at, DateTime.FormatPreset.RELATIVE)
# -> "5 minutes ago"
```

For `format_now_preset(DateTime.FormatPreset.RELATIVE)`, the script returns:

```gdscript
"just now"
```

That is intentional.

---

## ⚡ Quick Presets

```gdscript
DateTime.short_date(ts)
# -> "03/18/2026"

DateTime.long_date(ts)
# -> "Wednesday, March 18, 2026"

DateTime.short_time(ts)
# -> "8:14 PM"

DateTime.short_time(ts, true)
# -> "20:14"

DateTime.long_time(ts)
# -> "8:14:32 PM"

DateTime.long_time(ts, true)
# -> "20:14:32"

DateTime.date_time(ts)
# -> "03/18/2026 8:14 PM"
```

---

## ⏳ Relative Time

```gdscript
DateTime.relative_from_unix(DateTime.now_unix() - 300)
# -> "5 minutes ago"

DateTime.relative_from_unix(DateTime.now_unix() + 7200)
# -> "in 2 hours"
```

```gdscript
DateTime.relative_from_seconds(-45)
# -> "45 seconds ago"

DateTime.relative_from_seconds(120)
# -> "in 2 minutes"
```

---

## 🔄 Conversions

### Unix -> Dictionary

```gdscript
DateTime.unix_to_dict(ts)
# -> { "year": 2026, "month": 3, "day": 18, "hour": 20, "minute": 14, "second": 32 }
```

### Dictionary -> Unix

```gdscript
DateTime.dict_to_unix({
	"year": 2026,
	"month": 3,
	"day": 18,
	"hour": 20,
	"minute": 14,
	"second": 32
})
# -> 1773887272
```

---

## 🧠 Best Way to Use It in Components

For most UI components, expose both a preset and a custom format. That gives you easy inspector control without losing flexibility.

```gdscript
@export var use_preset: bool = true
@export var preset: DateTime.FormatPreset = DateTime.FormatPreset.LONG_TIME_12
@export var custom_format: String = "h:mm:ss A"
```

Then:

```gdscript
func get_display_text() -> String:
	if use_preset:
		return DateTime.format_now_preset(preset)
	return DateTime.format_now(custom_format)
```

This is a strong pattern for:
- clocks
- timestamps
- time cards
- inventory logs
- “last updated” labels
- shift displays

---

## ⏰ Example: Real-Time Clock Component

A clock component can use `DateTime` as the formatter while the component itself just refreshes the text.

```gdscript
@tool
extends Label
class_name EZClock

@export var use_preset: bool = true
@export var preset: DateTime.FormatPreset = DateTime.FormatPreset.LONG_TIME_12:
	set(value):
		preset = value
		_refresh()

@export var custom_format: String = "h:mm:ss A":
	set(value):
		custom_format = value
		_refresh()

@export var run_in_editor: bool = true:
	set(value):
		run_in_editor = value
		_update_process_mode()

@export var prefix: String = "":
	set(value):
		prefix = value
		_refresh()

@export var suffix: String = "":
	set(value):
		suffix = value
		_refresh()

var _last_second: int = -1

func _ready() -> void:
	_update_process_mode()
	_refresh()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() and not run_in_editor:
		return

	var now: Dictionary = DateTime.now_dict()
	var current_second: int = int(now.get("second", -1))

	if current_second != _last_second:
		_last_second = current_second
		_refresh()

func _refresh() -> void:
	if not is_node_ready():
		return

	var value: String = DateTime.format_now_preset(preset) if use_preset else DateTime.format_now(custom_format)
	text = prefix + value + suffix

func _update_process_mode() -> void:
	if Engine.is_editor_hint():
		set_process(run_in_editor)
	else:
		set_process(true)
```

Example inspector setups:

```gdscript
preset = DateTime.FormatPreset.LONG_TIME_12
# -> 8:14:32 PM
```

```gdscript
preset = DateTime.FormatPreset.SHORT_TIME_24
# -> 20:14
```

```gdscript
preset = DateTime.FormatPreset.LONG_DATE
# -> Wednesday, March 18, 2026
```

---

## 🧱 Best Practices

### Always store Unix timestamps

```gdscript
var created_at := DateTime.now_unix()
```

### Never store formatted strings

Bad:

```gdscript
"March 18, 2026"
```

Good:

```gdscript
1773885600
```

### Format only in UI

```gdscript
label.text = DateTime.format_unix(ts, "MMMM D, YYYY")
```

or:

```gdscript
label.text = DateTime.format_unix_preset(ts, DateTime.FormatPreset.LONG_DATE)
```

---

## ⚠️ Notes

- Godot uses Unix timestamps
- This utility is great for formatting and display
- It is not a full timezone management system
- For most app UI, that is completely fine

---

## ✅ Good Use Cases

This autoload works especially well for:

- real-time clocks
- shift start/end display
- employee time cards
- inventory update timestamps
- status labels like “last synced”
- relative labels like “2 hours ago”

---

## 🔮 Future Improvements

Optional ideas if you expand it later:

- "Today / Yesterday / Tomorrow" helpers
- escaped format text like `[Logged at] h:mm A`
- localization / translated month names
- timezone offset support
- parsing formatted strings back into datetime dictionaries

---

## Final Advice

Store raw -> format in UI -> never mix concerns.

That one rule will keep your app way cleaner.
