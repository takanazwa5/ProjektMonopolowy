class_name NPCUnloadingProductsOnCounterState extends NPCState


@onready var animation_tree: AnimationTree = %AnimationTree


func enter() -> void:
	animation_tree.animation_finished.connect(_on_animation_finished)
	Counter.instance.product_placed.connect(_on_counter_product_placed)

	if not npc.inventory.get_items().is_empty():
		print("%s ma loot w eq. Odkłada produkty na ladę." % npc.name)
		animation_tree.set(&"parameters/put_down/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		transition.emit(npc.brain.get_next_state(self))

func input_event(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"Rig/PutDown_Base":
		_unload_inventory_on_counter()

func _on_counter_product_placed(item_data: ProductData) -> void:
	if npc.wanted_products.has(item_data.name):
		npc.wanted_products.erase(item_data.name)

func _unload_inventory_on_counter() -> void:
	for item: Item in npc.inventory.get_items():
		Counter.instance.place_item_from_npc(item)

	transition.emit(npc.brain.get_next_state(self))

func exit() -> void:
	animation_tree.animation_finished.disconnect(_on_animation_finished)
	Counter.instance.product_placed.disconnect(_on_counter_product_placed)
