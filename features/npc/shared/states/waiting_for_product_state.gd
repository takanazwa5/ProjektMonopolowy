class_name NPCWaitingForProductState extends NPCState


@onready var animation_tree: AnimationTree = %AnimationTree
@onready var paying_state: NPCPayingState = %PayingState


func enter() -> void:
	animation_tree.animation_finished.connect(_on_animation_finished)
	Counter.instance.item_placed.connect(_on_counter_item_placed)
	npc.set_meta(&"can_interact", true)
	print("Basiula podeszla do lady. Tu bedzie okienko dialogowe. Na razie czeka na bobra w butelce.")

	if not npc.inventory.get_items().is_empty():
		print("Basiula ma loot w eq. Odkłada produkty na ladę.")
		animation_tree.set(&"parameters/put_down/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

	if npc.wanted_products.is_empty():
		transition.emit(paying_state)

func input_event(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"Rig/PutDown_Base":
		_unload_inventory_on_counter()

func _on_counter_item_placed(item_data: ItemData) -> void:
	if npc.wanted_products.has(item_data.name):
		npc.wanted_products.erase(item_data.name)

	if npc.wanted_products.is_empty():
		transition.emit(paying_state)

func _unload_inventory_on_counter() -> void:
	for item: Item in npc.inventory.get_items():
		var interact_event: InputEventAction = InputEventAction.new()
		interact_event.action = &"interact"
		interact_event.pressed = true
		Counter.instance.interact(interact_event, item)

func exit() -> void:
	animation_tree.animation_finished.disconnect(_on_animation_finished)
	Counter.instance.item_placed.disconnect(_on_counter_item_placed)
	npc.set_meta(&"can_interact", false)
