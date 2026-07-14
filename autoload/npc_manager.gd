extends Node


signal npc_entered_tree(npc: NPC)


var npcs_in_tree: Array[NPC]


func register(npc: NPC) -> void:
	npcs_in_tree.append(npc)
	npc_entered_tree.emit(npc)
