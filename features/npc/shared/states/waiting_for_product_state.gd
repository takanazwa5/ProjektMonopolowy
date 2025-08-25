class_name NPCWaitingForProductState extends NPCState


@onready var paying_state: NPCPayingState = %PayingState


func _ready() -> void:

	Level.counter.item_placed.connect(_on_counter_item_placed)


func enter() -> void:

	print("Basiula podeszla do lady. Tu bedzie okienko dialogowe. Na razie czeka na bobra w butelce.")


func _on_counter_item_placed(item: Item) -> void:

	if not item.item_name == "BobrButla": return
	transition.emit(paying_state)
