class_name Dialogue extends Control


signal dialogue_started
signal dialogue_ended


const LINES: JSON = preload("res://features/dialogue/lines.json")


@onready var text: Label = %Text
@onready var answers_container: VBoxContainer = %AnswersContainer


func _init() -> void:

	Global.dialogue = self


func start_dialogue(line_id: String) -> void:

	if not visible: dialogue_started.emit()
	var line_data: Dictionary = LINES.data[line_id]
	text.text = "%s: %s" % [line_data["speaker"], line_data["text"]]
	if line_data["choices"] == null:

		var answer_button: Button = Button.new()
		answer_button.text = "[END CONVERSATION]"
		answer_button.pressed.connect(_on_answer_button_pressed.bind(null))
		answers_container.add_child(answer_button)

	else:

		for choice: Dictionary in line_data["choices"]:

			var answer_button: Button = Button.new()
			answer_button.text = choice["text"]
			answer_button.pressed.connect(_on_answer_button_pressed.bind(choice["next"]))
			answers_container.add_child(answer_button)

	show()


func _end_dialogue() -> void:

	dialogue_ended.emit()
	hide()
	text.text = ""
	for child: Label in answers_container.get_children():

		child.queue_free()


func _on_answer_button_pressed(next: String) -> void:

	if next == null: _end_dialogue()
	else: start_dialogue(next)
