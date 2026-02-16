class_name NPCPayingState extends NPCState


@onready var animation_tree: AnimationTree = %AnimationTree
@onready var packing_state: NPCPackingState = %PackingState


func enter() -> void:

	animation_tree.animation_finished.connect(_on_animation_finished)
	CashRegister.instance.transaction_finished.connect(_on_transaction_finished)
	animation_tree.set(&"parameters/put_down/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func input_event(_event: InputEvent) -> void:

	pass


func update(_delta: float) -> void:

	pass


func physics_update(_delta: float) -> void:

	pass


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"Rig/PutDown_Base":
		_unload_inventory_on_counter()
		CashRegister.instance.generate_random_order()

func _unload_inventory_on_counter() -> void:
	for item: Item in npc.inventory.get_items():
		var interact_event: InputEventAction = InputEventAction.new()
		interact_event.action = &"interact"
		interact_event.pressed = true
		Counter.instance.interact(interact_event, item)

func _on_transaction_finished() -> void:

	transition.emit(packing_state)


func exit() -> void:

	animation_tree.animation_finished.disconnect(_on_animation_finished)
	CashRegister.instance.transaction_finished.disconnect(_on_transaction_finished)
