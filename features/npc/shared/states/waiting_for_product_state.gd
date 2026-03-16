class_name NPCWaitingForProductState extends NPCState


@onready var animation_tree: AnimationTree = %AnimationTree


func enter() -> void:
	Counter.instance.item_placed.connect(_on_counter_item_placed)
	npc.set_meta(&"can_interact", true)
	print("%s podchodzi do lady. Tu bedzie okienko dialogowe. Na razie czeka na : %s" % [npc.name, ", ".join(npc.wanted_products)])

func input_event(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass

func _on_counter_item_placed(item_data: ItemData) -> void:
	if npc.wanted_products.has(item_data.name):
		npc.wanted_products.erase(item_data.name)

	if npc.wanted_products.is_empty():
		transition.emit(npc.brain.get_next_state(self))

func exit() -> void:
	Counter.instance.item_placed.disconnect(_on_counter_item_placed)
	npc.set_meta(&"can_interact", false)
