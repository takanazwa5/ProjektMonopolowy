class_name DialogueUI extends Control


signal dialogue_ended
signal next_line_requested(next: String)
signal line_change_requested(change_to: String)


@onready var npc_text: Label = %NPCText
@onready var answers_container: VBoxContainer = %AnswersContainer


func _init() -> void:
	DialogueManager.dialogue_ui = self


func start_dialogue(speaker: String, text: String, answers: Array) -> void:
	for answer: Node in answers_container.get_children():
		answer.queue_free()

	npc_text.text = "%s: %s" % [speaker, text]

	if answers.is_empty():
		_add_answer("")

	for answer: Dictionary in answers:
		_add_answer(answer.get("text"), answer.get("next", ""), answer.get("change_to", ""))

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()


func _add_answer(text: String, next: String = "", change_to: String = "") -> void:
	var answer_button: Button = Button.new()
	answer_button.text = text
	answers_container.add_child(answer_button)
	answer_button.pressed.connect(_on_answer_button_pressed.bind(next, change_to))
	if next.is_empty():
		answer_button.text += " [END CONVERSATION]"


func _end_dialogue() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	dialogue_ended.emit()


func _on_answer_button_pressed(next: String, change_to: String) -> void:
	if not change_to.is_empty():
		line_change_requested.emit(change_to)

	if not next.is_empty():
		next_line_requested.emit(next)

	else:
		_end_dialogue()
