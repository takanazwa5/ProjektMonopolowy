class_name NPCEnteringStoreState extends NPCState


@onready var waiting_for_product_state: NPCWaitingForProductState = %WaitingForProductState
@onready var getting_product_state: NPCGettingProductState = %GettingProductState



func enter() -> void:

	print("Basiula wchodzi do sklepu...")
	await get_tree().create_timer(5.0).timeout
	print("Basiula skonczyla wchodzic do sklepu.")
	var wants_help: bool = [true, false].pick_random()
	print("Tu bedzie losowanie produktow, jakie chce Basiula. Na razie chce browara.")
	npc.wanted_products = Level.instance.available_items.get_all_item_names()
	print("Basiula chce: ", npc.wanted_products)
	if wants_help:
		print("Basiula jest leniwa i chce miec produkt przyniesiony na lade.")
		npc.navigate_to_node(Counter.instance)
		await npc.nav_agent.navigation_finished
		transition.emit(waiting_for_product_state)

	else:
		print("Basiula sama sobie znajdzie produkt.")
		transition.emit(getting_product_state)


func input_event(_event: InputEvent) -> void:

	pass


func update(_delta: float) -> void:

	pass


func physics_update(_delta: float) -> void:

	pass


func exit() -> void:

	pass
