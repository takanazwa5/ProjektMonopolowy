class_name NPCWaitingForProductState extends NPCState


@onready var paying_state: NPCPayingState = %PayingState


func enter() -> void:

	var counter: Counter = get_tree().get_first_node_in_group(&"counter")
	counter.item_placed.connect(_on_counter_item_placed)
	print("Basiula podeszla do lady. Tu bedzie okienko dialogowe. Na razie czeka na bobra w butelce.")


func input_event(_event: InputEvent) -> void:

	pass


func update(_delta: float) -> void:

	pass


func physics_update(_delta: float) -> void:

	pass


func _on_counter_item_placed(item_data: ItemData) -> void:

	if not item_data.name == "bubr_bottle": return
	transition.emit(paying_state)


func exit() -> void:

	var counter: Counter = get_tree().get_first_node_in_group(&"counter")
	counter.item_placed.disconnect(_on_counter_item_placed)
