class_name NPCWaitingForProductState extends NPCState


@onready var paying_state: NPCPayingState = %PayingState


func enter() -> void:

	Level.counter.item_placed.connect(_on_counter_item_placed)
	print("Basiula podeszla do lady. Tu bedzie okienko dialogowe. Na razie czeka na bobra w butelce.")


func _on_counter_item_placed(item: Item) -> void:

	if not item.item_name == "BobrButla": return
	transition.emit(paying_state)


func exit() -> void:

	Level.counter.item_placed.disconnect(_on_counter_item_placed)
