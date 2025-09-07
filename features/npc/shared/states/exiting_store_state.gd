class_name NPCExitingStoreState extends NPCState


func enter() -> void:

	print("Basia wychodzi ze sklepu")
	npc.navigate_to_node(Level.main_door)
	await npc.navigation_agent_3d.navigation_finished
	npc.call_deferred(&"queue_free") # NOTE: Crash when not deferred
