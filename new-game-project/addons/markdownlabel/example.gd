@tool
extends Control

@export var text: String = "":
	set(v):
		text = v
		markdown_label_file.text = text

@onready var markdown_label_file: MarkdownLabel = %MarkdownLabelFile


func _ready() -> void:
	markdown_label_file.display_file("res://addons/markdownlabel/README.md")
	markdown_label_file.task_checkbox_clicked.connect(
		func(id: int, line: int, checked: bool, text: String) -> void:
			print("%s task #%d on line %d: %s" % ["Checked" if checked else "Unchecked", id, line, text])
	)
