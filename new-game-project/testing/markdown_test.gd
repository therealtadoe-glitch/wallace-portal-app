@tool
extends Control

@onready var label: MarkdownLabel = %MarkdownLabelFile

@export var code: String = "N/A":
	set(v):
		code = v
		if label && label.text != "N/A":
			label.text = code

func _ready() -> void:
	label.display_file("res://src/autoloads/DOCS.md", true)
	label.task_checkbox_clicked.connect(
		func(id: int, line: int, checked: bool, text: String) -> void:
			print("%s task #%d on line %d: %s" % ["Checked" if checked else "Unchecked", id, line, text])
	)
