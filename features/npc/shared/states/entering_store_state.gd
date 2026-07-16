class_name NPCEnteringStoreState extends NPCState


func enter() -> void:
	print("%s wchodzi do sklepu..." % npc.name)
	await get_tree().create_timer(5.0).timeout
	print("%s skonczyla wchodzic do sklepu." % npc.name)

	print("Tu bedzie losowanie produktow, jakie chce %s." % npc.name)
	for i in range(npc.number_of_products_wanted):
		var item_names_by_type: Dictionary[ItemData.Type, Array] = Level.instance.available_items.item_names_by_type

		var available_categories: Array[ItemData.Type] = npc.wanted_product_categories.filter(func(category: ItemData.Type) -> bool:
			return item_names_by_type[category].size() > 0
		)

		var random_category: ItemData.Type = available_categories.pick_random()
		var random_product: StringName = item_names_by_type[random_category].pick_random()
		if random_product != null:
			npc.wanted_products.append(random_product)

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
