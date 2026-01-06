class_name NPCExitingStoreState extends NPCState


func enter() -> void:

	print("Basia wychodzi ze sklepu")
	npc.navigate_to_node(Global.level.main_door)
	await npc.nav_agent.navigation_finished
	npc.call_deferred(&"queue_free") # NOTE: Crash when not deferred


func input_event(_event: InputEvent) -> void:

	pass


func update(_delta: float) -> void:

	pass


func physics_update(_delta: float) -> void:

	pass


func exit() -> void:

	pass
