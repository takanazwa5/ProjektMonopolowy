class_name NPCComingToStoreState extends NPCState


@onready var waiting_for_product_state: NPCWaitingForProductState = %WaitingForProductState
@onready var getting_product_state: NPCGettingProductState = %GettingProductState



func enter() -> void:

	print("Basiula wchodzi do sklepu...")
	await get_tree().create_timer(5.0).timeout
	print("Basiula skonczyla wchodzic do sklepu.")
	var wants_help: bool = [true, false].pick_random()
	wants_help = false
	print("Tu bedzie losowanie produktow, jakie chce Basiula. Na razie chce browara.")
	if wants_help:

		print("Basiula jest leniwa i chce miec produkt przyniesiony na lade.")
		npc.navigate_to_node(Level.counter)
		await npc.navigation_agent_3d.navigation_finished
		transition.emit(waiting_for_product_state)

	else:

		print("Basiula sama sobie znajdzie produkt.")
		transition.emit(getting_product_state)
