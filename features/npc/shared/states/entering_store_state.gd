class_name NPCEnteringStoreState extends NPCState


func enter() -> void:
	print("%s wchodzi do sklepu..." % npc.name)
	await get_tree().create_timer(5.0).timeout
	print("%s skonczyla wchodzic do sklepu." % npc.name)
	print("Tu bedzie losowanie produktow, jakie chce %s." % npc.name)
	npc.wanted_products = Level.instance.available_items.get_all_item_names().slice(0, 2)
	print("%s chce: %s" % [npc.name, ", ".join(npc.wanted_products)])
	transition.emit(npc.brain.get_next_state(self))


func input_event(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func exit() -> void:
	pass
