class_name DialogueUI extends Control


signal dialogue_ended


@onready var npc_text: Label = %NPCText
@onready var answers_container: VBoxContainer = %AnswersContainer


func _init() -> void:
	DialogueManager.dialogue_ui = self


func start_dialogue(speaker: String, text: String, answers: Array[String]) -> void:
	for answer: Node in answers_container.get_children():
		answer.free()

	npc_text.text = "%s: %s" % [speaker, text]

	if answers.is_empty():
		_add_answer("[END CONVERSATION]")

	for answer: String in answers:
		_add_answer(answer)

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()


func _add_answer(text: String) -> void:
	var answer_button: Button = Button.new()
	answer_button.text = text
	answers_container.add_child(answer_button)
	answer_button.pressed.connect(_on_answer_button_pressed)


func _end_dialogue() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	dialogue_ended.emit()


func _on_answer_button_pressed() -> void:
	_end_dialogue()
