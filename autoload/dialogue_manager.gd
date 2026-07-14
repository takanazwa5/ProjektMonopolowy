extends Node


signal dialogue_started
signal dialogue_ended


const LINES: JSON = preload("res://features/dialogue/lines.json")


var dialogue_ui: DialogueUI
var lines: Dictionary = LINES.data
var _current_npc: NPC # Currently speaking NPC
var _line_change: String


func _ready() -> void:
	dialogue_ui.dialogue_ended.connect(_on_dialogue_ended)
	NPCManager.npc_entered_tree.connect(_on_npc_entered_tree)
	dialogue_ui.next_line_requested.connect(_on_next_line_requested)
	dialogue_ui.line_change_requested.connect(_on_line_change_requested)


func _parse_line_data(line_id: String) -> Array:
	var line_data: Dictionary = lines.get(line_id)
	var speaker: String = line_data.get("speaker")
	var text: String = line_data.get("text")
	var answers: Array = line_data.get("answers", [])
	_line_change = line_data.get("change_to", "")
	return [speaker, text, answers]


func _on_npc_interaction(npc: NPC) -> void:
	_current_npc = npc
	var line_data: Array = _parse_line_data(npc.dialogue_line)
	dialogue_ui.start_dialogue(line_data[0], line_data[1], line_data[2])
	dialogue_started.emit()


func _on_next_line_requested(next: String) -> void:
	var line_data: Array = _parse_line_data(next)
	dialogue_ui.start_dialogue(line_data[0], line_data[1], line_data[2])


func _on_line_change_requested(change_to: String) -> void:
	_line_change = change_to


func _on_dialogue_ended() -> void:
	dialogue_ended.emit()
	if not _line_change.is_empty():
		_current_npc.dialogue_line = _line_change
	_current_npc = null


func _on_npc_entered_tree(npc: NPC) -> void:
	npc.interaction.connect(_on_npc_interaction)
