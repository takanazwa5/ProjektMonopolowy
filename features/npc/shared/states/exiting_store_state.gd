class_name NPCExitingStoreState extends NPCState


func enter() -> void:

	print("Basia wychodzi ze sklepu")
	npc.call_deferred(&"queue_free") # NOTE: Crash when not deferred
