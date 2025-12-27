class_name Dialogue extends Control


signal dialogue_started
signal dialogue_ended


const LINES: JSON = preload("res://features/dialogue/lines.json")


@onready var text: Label = %Text
@onready var answers_container: VBoxContainer = %AnswersContainer
@onready var npcs: Node = %NPCs


func _init() -> void:

	Global.dialogue = self


func _ready() -> void:

	npcs.child_entered_tree.connect(_on_npc_entered_tree)
	npcs.child_exiting_tree.connect(_on_npc_exiting_tree)


func start_dialogue(line_id: String) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_clear_answers()
	if not visible: dialogue_started.emit()
	var line_data: Dictionary = LINES.data[line_id]
	text.text = "%s: %s" % [line_data["speaker"], line_data["text"]]
	if line_data["choices"] == null:

		var answer_button: Button = Button.new()
		answer_button.text = "[END CONVERSATION]"
		answer_button.pressed.connect(_on_answer_button_pressed)
		answers_container.add_child(answer_button)

	else:

		for choice: Dictionary in line_data["choices"]:

			var answer_button: Button = Button.new()
			answer_button.text = choice["text"]
			if choice["next"] == null:

				answer_button.pressed.connect(_on_answer_button_pressed)

			else:

				answer_button.pressed.connect(_on_answer_button_pressed.bind(choice["next"]))

			answers_container.add_child(answer_button)

	show()


func _end_dialogue() -> void:

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	dialogue_ended.emit()
	hide()
	text.text = ""
	_clear_answers()


func _clear_answers() -> void:

	for child: Button in answers_container.get_children():

		child.queue_free()


func _on_answer_button_pressed(next: String = "") -> void:

	if next.is_empty(): _end_dialogue()
	else: start_dialogue(next)


func _on_npc_entered_tree(npc: NPC) -> void:

	npc.interaction.connect(_on_npc_interaction)


func _on_npc_exiting_tree(npc: NPC) -> void:

	npc.interaction.disconnect(_on_npc_interaction)


func _on_npc_interaction() -> void:

	start_dialogue("npc_basia_001") # TODO: For now.
