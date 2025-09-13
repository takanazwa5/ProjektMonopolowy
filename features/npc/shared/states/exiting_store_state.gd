class_name NPCExitingStoreState extends NPCState


func enter() -> void:

	print("Basia wychodzi ze sklepu")
	var main_door: Node3D = get_tree().get_first_node_in_group(&"main_door")
	npc.navigate_to_node(main_door)
	await npc.navigation_agent_3d.navigation_finished
	npc.call_deferred(&"queue_free") # NOTE: Crash when not deferred
