extends Node


signal dialogue_started
signal dialogue_ended


const LINES: JSON = preload("res://features/dialogue/lines.json")


var dialogue_ui: DialogueUI
var lines: Dictionary = LINES.data


func _ready() -> void:
	dialogue_ui.dialogue_ended.connect(_on_dialogue_ended)
	NPCManager.npc_entered_tree.connect(_on_npc_entered_tree)


func _on_npc_interaction(npc: NPC) -> void:
	var line_data: Dictionary = lines.get(npc.dialogue_line)
	var speaker: String = line_data.get("speaker")
	var text: String = line_data.get("text")
	var answers_dict: Array = line_data.get("answers", [])
	var answers: Array[String] = []

	for answer_dict: Dictionary in answers_dict:
		var answer_text: String = answer_dict.get("text")
		if not answer_dict.has("next"):
			answer_text += " [END CONVERSATION]"
		answers.append(answer_text)

	dialogue_ui.start_dialogue(speaker, text, answers)
	dialogue_started.emit()


func _on_dialogue_ended() -> void:
	dialogue_ended.emit()


func _on_npc_entered_tree(npc: NPC) -> void:
	npc.interaction.connect(_on_npc_interaction)
