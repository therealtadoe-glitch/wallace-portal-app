@tool
extends Node

enum FormatPreset {
	SHORT_DATE,
	LONG_DATE,
	SHORT_TIME_12,
	LONG_TIME_12,
	SHORT_TIME_24,
	LONG_TIME_24,
	DATE_TIME_12,
	DATE_TIME_24,
	FULL_DATE_TIME_12,
	FULL_DATE_TIME_24,
	ISO_DATE,
	ISO_TIME,
	ISO_DATE_TIME,
	WEEKDAY_SHORT,
	WEEKDAY_LONG,
	MONTH_DAY,
	MONTH_DAY_YEAR,
	RELATIVE
}

const MONTHS_FULL: PackedStringArray = [
	"", "January", "February", "March", "April", "May", "June",
	"July", "August", "September", "October", "November", "December"
]

const MONTHS_SHORT: PackedStringArray = [
	"", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
	"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
]

const WEEKDAYS_FULL: PackedStringArray = [
	"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
]

const WEEKDAYS_SHORT: PackedStringArray = [
	"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
]


# ==================================================
# CURRENT TIME
# ==================================================

## Returns the current Unix timestamp.
## Example:
## DateTime.now_unix() -> 1773885600
func now_unix() -> int:
	return int(Time.get_unix_time_from_system())


## Returns the current system datetime dictionary.
## Example:
## DateTime.now_dict() -> {"year": 2026, "month": 3, "day": 18, "hour": 20, "minute": 14, "second": 32}
func now_dict() -> Dictionary:
	return _system_datetime_dict()


# ==================================================
# PRESET API
# ==================================================

## Returns the format pattern string for a preset.
## Example:
## DateTime.get_pattern(DateTime.FormatPreset.SHORT_DATE) -> "MM/DD/YYYY"
func get_pattern(preset: FormatPreset) -> String:
	match preset:
		FormatPreset.SHORT_DATE:
			return "MM/DD/YYYY"
		FormatPreset.LONG_DATE:
			return "dddd, MMMM D, YYYY"

		FormatPreset.SHORT_TIME_12:
			return "h:mm A"
		FormatPreset.LONG_TIME_12:
			return "h:mm:ss A"

		FormatPreset.SHORT_TIME_24:
			return "HH:mm"
		FormatPreset.LONG_TIME_24:
			return "HH:mm:ss"

		FormatPreset.DATE_TIME_12:
			return "MM/DD/YYYY h:mm A"
		FormatPreset.DATE_TIME_24:
			return "MM/DD/YYYY HH:mm"

		FormatPreset.FULL_DATE_TIME_12:
			return "dddd, MMMM D, YYYY h:mm:ss A"
		FormatPreset.FULL_DATE_TIME_24:
			return "dddd, MMMM D, YYYY HH:mm:ss"

		FormatPreset.ISO_DATE:
			return "YYYY-MM-DD"
		FormatPreset.ISO_TIME:
			return "HH:mm:ss"
		FormatPreset.ISO_DATE_TIME:
			return "YYYY-MM-DDTHH:mm:ss"

		FormatPreset.WEEKDAY_SHORT:
			return "ddd"
		FormatPreset.WEEKDAY_LONG:
			return "dddd"

		FormatPreset.MONTH_DAY:
			return "MMMM D"
		FormatPreset.MONTH_DAY_YEAR:
			return "MMMM D, YYYY"

		FormatPreset.RELATIVE:
			return ""

	return "YYYY-MM-DD HH:mm:ss"


## Formats a Unix timestamp using a preset.
## Example:
## DateTime.format_unix_preset(1773885600, DateTime.FormatPreset.SHORT_DATE) -> "03/18/2026"
## DateTime.format_unix_preset(1773885600, DateTime.FormatPreset.LONG_TIME_12) -> "8:00:00 PM"
func format_unix_preset(unix_time: int, preset: FormatPreset) -> String:
	if preset == FormatPreset.RELATIVE:
		return relative_from_unix(unix_time)
	return format_unix(unix_time, get_pattern(preset))


## Formats the current system date/time using a preset.
## Example:
## DateTime.format_now_preset(DateTime.FormatPreset.LONG_DATE) -> "Wednesday, March 18, 2026"
## DateTime.format_now_preset(DateTime.FormatPreset.SHORT_TIME_24) -> "20:14"
func format_now_preset(preset: FormatPreset) -> String:
	if preset == FormatPreset.RELATIVE:
		return "just now"
	return format_now(get_pattern(preset))


## Formats a datetime dictionary using a preset.
## Example:
## DateTime.format_dict_preset({"year": 2026, "month": 3, "day": 18}, DateTime.FormatPreset.MONTH_DAY_YEAR) -> "March 18, 2026"
func format_dict_preset(datetime: Dictionary, preset: FormatPreset) -> String:
	if preset == FormatPreset.RELATIVE:
		return relative_from_unix(dict_to_unix(datetime))
	return format_dict(datetime, get_pattern(preset))


# ==================================================
# FINAL FORMATTERS
# ==================================================

## Formats a Unix timestamp using a custom token pattern.
## Example:
## DateTime.format_unix(1773885600, "YYYY-MM-DD") -> "2026-03-18"
## DateTime.format_unix(1773885600, "MMMM D, YYYY") -> "March 18, 2026"
## DateTime.format_unix(1773885600, "h:mm A") -> "8:00 PM"
func format_unix(unix_time: int, pattern: String = "YYYY-MM-DD HH:mm:ss") -> String:
	return format_dict(unix_to_dict(unix_time), pattern)


## Formats a datetime dictionary using a custom token pattern.
## Example:
## DateTime.format_dict({"year": 2026, "month": 3, "day": 18}, "MM/DD/YYYY") -> "03/18/2026"
## DateTime.format_dict({"year": 2026, "month": 3, "day": 18, "hour": 20, "minute": 14}, "h:mm A") -> "8:14 PM"
func format_dict(datetime: Dictionary, pattern: String = "YYYY-MM-DD HH:mm:ss") -> String:
	var dt: Dictionary = enrich_datetime(normalize_datetime_dict(datetime))
	return _apply_pattern(pattern, dt)


## Formats the current system date/time using a custom token pattern.
## Example:
## DateTime.format_now("dddd, MMMM Do YYYY") -> "Wednesday, March 18th 2026"
## DateTime.format_now("h:mm A") -> "8:14 PM"
func format_now(pattern: String = "YYYY-MM-DD HH:mm:ss") -> String:
	return format_dict(now_dict(), pattern)


## Formats a Unix timestamp as an ISO-style datetime string.
## Example:
## DateTime.iso_from_unix(1773885600) -> "2026-03-18T20:00:00"
func iso_from_unix(unix_time: int) -> String:
	return format_unix(unix_time, "YYYY-MM-DDTHH:mm:ss")


## Returns a relative time label compared to now.
## Example:
## DateTime.relative_from_unix(DateTime.now_unix() - 300) -> "5 minutes ago"
## DateTime.relative_from_unix(DateTime.now_unix() + 7200) -> "in 2 hours"
func relative_from_unix(unix_time: int, include_suffix: bool = true) -> String:
	var diff: int = unix_time - now_unix()
	return relative_from_seconds(diff, include_suffix)


## Returns a relative time label from a seconds difference.
## Example:
## DateTime.relative_from_seconds(-300) -> "5 minutes ago"
## DateTime.relative_from_seconds(7200) -> "in 2 hours"
## DateTime.relative_from_seconds(45, false) -> "45 seconds"
func relative_from_seconds(seconds: int, include_suffix: bool = true) -> String:
	var future: bool = seconds > 0
	var abs_seconds: int = absi(seconds)

	if abs_seconds < 5:
		return "in a moment" if future else "just now"

	var value: int = 0
	var unit: String = ""

	if abs_seconds < 60:
		value = abs_seconds
		unit = "second"
	elif abs_seconds < 3600:
		value = int(abs_seconds / 60)
		unit = "minute"
	elif abs_seconds < 86400:
		value = int(abs_seconds / 3600)
		unit = "hour"
	elif abs_seconds < 604800:
		value = int(abs_seconds / 86400)
		unit = "day"
	elif abs_seconds < 2629800:
		value = int(abs_seconds / 604800)
		unit = "week"
	elif abs_seconds < 31557600:
		value = int(abs_seconds / 2629800)
		unit = "month"
	else:
		value = int(abs_seconds / 31557600)
		unit = "year"

	var label: String = "%d %s%s" % [value, unit, "" if value == 1 else "s"]

	if not include_suffix:
		return label

	return "in %s" % label if future else "%s ago" % label


## Formats a 12-hour clock string.
## Example:
## DateTime.format_clock_12(20, 14) -> "8:14 PM"
## DateTime.format_clock_12(20, 14, 32, true) -> "8:14:32 PM"
## DateTime.format_clock_12(20, 14, 0, false, true) -> "8:14 pm"
func format_clock_12(hour: int, minute: int, second: int = 0, include_seconds: bool = false, lowercase_meridiem: bool = false) -> String:
	var hour_12: int = _to_12h(hour)
	var meridiem: String = "pm" if hour >= 12 else "am"

	if not lowercase_meridiem:
		meridiem = meridiem.to_upper()

	if include_seconds:
		return "%d:%02d:%02d %s" % [hour_12, minute, second, meridiem]

	return "%d:%02d %s" % [hour_12, minute, meridiem]


## Formats a 24-hour clock string.
## Example:
## DateTime.format_clock_24(20, 14) -> "20:14"
## DateTime.format_clock_24(20, 14, 32, true) -> "20:14:32"
func format_clock_24(hour: int, minute: int, second: int = 0, include_seconds: bool = false) -> String:
	if include_seconds:
		return "%02d:%02d:%02d" % [hour, minute, second]

	return "%02d:%02d" % [hour, minute]


## Formats a short date string.
## Example:
## DateTime.short_date(1773885600) -> "03/18/2026"
func short_date(unix_time: int) -> String:
	return format_unix(unix_time, get_pattern(FormatPreset.SHORT_DATE))


## Formats a long date string.
## Example:
## DateTime.long_date(1773885600) -> "Wednesday, March 18, 2026"
func long_date(unix_time: int) -> String:
	return format_unix(unix_time, get_pattern(FormatPreset.LONG_DATE))


## Formats a short time string.
## Example:
## DateTime.short_time(1773885600) -> "8:00 PM"
## DateTime.short_time(1773885600, true) -> "20:00"
func short_time(unix_time: int, use_24h: bool = false) -> String:
	return format_unix(
		unix_time,
		get_pattern(FormatPreset.SHORT_TIME_24) if use_24h else get_pattern(FormatPreset.SHORT_TIME_12)
	)


## Formats a long time string.
## Example:
## DateTime.long_time(1773885600) -> "8:00:00 PM"
## DateTime.long_time(1773885600, true) -> "20:00:00"
func long_time(unix_time: int, use_24h: bool = false) -> String:
	return format_unix(
		unix_time,
		get_pattern(FormatPreset.LONG_TIME_24) if use_24h else get_pattern(FormatPreset.LONG_TIME_12)
	)


## Formats a combined date/time string.
## Example:
## DateTime.date_time(1773885600) -> "03/18/2026 8:00 PM"
## DateTime.date_time(1773885600, true) -> "03/18/2026 20:00"
func date_time(unix_time: int, use_24h: bool = false) -> String:
	return format_unix(
		unix_time,
		get_pattern(FormatPreset.DATE_TIME_24) if use_24h else get_pattern(FormatPreset.DATE_TIME_12)
	)


# ==================================================
# CONVERSIONS
# ==================================================

## Converts a Unix timestamp into a datetime dictionary.
## Example:
## DateTime.unix_to_dict(1773885600) -> {"year": 2026, "month": 3, "day": 18, "hour": 20, "minute": 0, "second": 0}
func unix_to_dict(unix_time: int) -> Dictionary:
	return normalize_datetime_dict(Time.get_datetime_dict_from_unix_time(unix_time))


## Converts a datetime dictionary into a Unix timestamp.
## Example:
## DateTime.dict_to_unix({"year": 2026, "month": 3, "day": 18, "hour": 20, "minute": 0, "second": 0}) -> 1773885600
func dict_to_unix(datetime: Dictionary) -> int:
	var clean: Dictionary = normalize_datetime_dict(datetime)
	return int(Time.get_unix_time_from_datetime_dict(clean))


# ==================================================
# NAME HELPERS
# ==================================================

## Returns a month name.
## Example:
## DateTime.month_name(3) -> "March"
## DateTime.month_name(3, true) -> "Mar"
func month_name(month: int, short: bool = false) -> String:
	if month < 1 or month > 12:
		return ""
	return MONTHS_SHORT[month] if short else MONTHS_FULL[month]


## Returns a weekday name.
## Example:
## DateTime.weekday_name(3) -> "Wednesday"
## DateTime.weekday_name(3, true) -> "Wed"
func weekday_name(weekday: int, short: bool = false) -> String:
	var index: int = posmod(weekday, 7)
	return WEEKDAYS_SHORT[index] if short else WEEKDAYS_FULL[index]


# ==================================================
# NORMALIZATION / ENRICHMENT
# ==================================================

## Fills in missing datetime keys and clamps values into safe ranges.
## Example:
## DateTime.normalize_datetime_dict({"year": 2026, "month": 3, "day": 18}) -> {"year": 2026, "month": 3, "day": 18, "hour": 0, "minute": 0, "second": 0}
func normalize_datetime_dict(datetime: Dictionary) -> Dictionary:
	return {
		"year": int(datetime.get("year", 1970)),
		"month": clampi(int(datetime.get("month", 1)), 1, 12),
		"day": clampi(int(datetime.get("day", 1)), 1, 31),
		"hour": clampi(int(datetime.get("hour", 0)), 0, 23),
		"minute": clampi(int(datetime.get("minute", 0)), 0, 59),
		"second": clampi(int(datetime.get("second", 0)), 0, 59)
	}


## Adds extra formatting values to a datetime dictionary.
## Example:
## DateTime.enrich_datetime({"year": 2026, "month": 3, "day": 18, "hour": 20}) -> {... "month_name": "March", "weekday_name": "Wednesday", "hour_12": 8, "am_pm": "PM", "ordinal_day": "18th"}
func enrich_datetime(datetime: Dictionary) -> Dictionary:
	var dt: Dictionary = normalize_datetime_dict(datetime)
	var unix_time: int = dict_to_unix(dt)

	dt["unix"] = unix_time
	dt["month_name"] = month_name(int(dt["month"]), false)
	dt["month_short"] = month_name(int(dt["month"]), true)

	var date_info: Dictionary = Time.get_date_dict_from_unix_time(unix_time)
	var weekday: int = int(date_info.get("weekday", 0))

	dt["weekday"] = weekday
	dt["weekday_name"] = weekday_name(weekday, false)
	dt["weekday_short"] = weekday_name(weekday, true)
	dt["hour_12"] = _to_12h(int(dt["hour"]))
	dt["am_pm"] = "AM" if int(dt["hour"]) < 12 else "PM"
	dt["am_pm_lower"] = "am" if int(dt["hour"]) < 12 else "pm"
	dt["ordinal_day"] = _ordinal(int(dt["day"]))

	return dt


# ==================================================
# INTERNALS
# ==================================================

func _system_datetime_dict() -> Dictionary:
	return normalize_datetime_dict(Time.get_datetime_dict_from_system())


func _apply_pattern(pattern: String, dt: Dictionary) -> String:
	var result: String = pattern

	var replacements: Dictionary = {
		"dddd": dt["weekday_name"],
		"ddd": dt["weekday_short"],
		"MMMM": dt["month_name"],
		"MMM": dt["month_short"],
		"YYYY": "%04d" % int(dt["year"]),
		"YY": "%02d" % (int(dt["year"]) % 100),
		"Do": dt["ordinal_day"],
		"DD": "%02d" % int(dt["day"]),
		"D": str(int(dt["day"])),
		"HH": "%02d" % int(dt["hour"]),
		"H": str(int(dt["hour"])),
		"hh": "%02d" % int(dt["hour_12"]),
		"h": str(int(dt["hour_12"])),
		"mm": "%02d" % int(dt["minute"]),
		"m": str(int(dt["minute"])),
		"ss": "%02d" % int(dt["second"]),
		"s": str(int(dt["second"])),
		"A": dt["am_pm"],
		"a": dt["am_pm_lower"],
		"MM": "%02d" % int(dt["month"]),
		"M": str(int(dt["month"]))
	}

	var ordered_tokens: PackedStringArray = [
		"dddd", "ddd",
		"MMMM", "MMM",
		"YYYY", "YY",
		"Do",
		"DD", "D",
		"HH", "H",
		"hh", "h",
		"mm", "m",
		"ss", "s",
		"A", "a",
		"MM", "M"
	]

	for token in ordered_tokens:
		result = result.replace(token, str(replacements[token]))

	return result


func _to_12h(hour: int) -> int:
	var h: int = hour % 12
	return 12 if h == 0 else h


func _ordinal(day: int) -> String:
	var mod100: int = day % 100

	if mod100 >= 11 and mod100 <= 13:
		return "%dth" % day

	match day % 10:
		1:
			return "%dst" % day
		2:
			return "%dnd" % day
		3:
			return "%drd" % day
		_:
			return "%dth" % day
