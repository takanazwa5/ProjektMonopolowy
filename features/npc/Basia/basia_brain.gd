class_name BasiaBrain
extends NPCBrain

var wants_help: bool

@onready var entering_store_state: NPCEnteringStoreState = %EnteringStoreState
@onready var waiting_for_product_state: NPCWaitingForProductState = %WaitingForProductState
@onready var getting_product_state: NPCGettingProductState = %GettingProductState
@onready var paying_state: NPCPayingState = %PayingState
@onready var packing_state: NPCPackingState = %PackingState
@onready var exiting_store_state: NPCExitingStoreState = %ExitingStoreState
@onready var standing_in_queue_state: NPCStandingInQueueState = %StandingInQueueState
@onready var unloading_products_on_counter_state: NPCUnloadingProductsOnCounterState = %UnloadingProductsOnCounterState

func _ready() -> void:
	state_transitions = [
		[entering_store_state, getting_product_state],
		[getting_product_state, standing_in_queue_state],
		[standing_in_queue_state, unloading_products_on_counter_state, self._has_items_to_unload],
		[standing_in_queue_state, waiting_for_product_state],
		[unloading_products_on_counter_state, waiting_for_product_state, self._wants_more_items],
		[unloading_products_on_counter_state, paying_state],
		[waiting_for_product_state, paying_state],
		[paying_state, packing_state],
		[packing_state, exiting_store_state],
	]

# TODO: this is a debug override, remove this
func get_next_state(state: NPCState) -> NPCState:
	print("Sprawdzam mozliwosc przejscia z ", state.name)
	var next_state: NPCState = super.get_next_state(state)
	print("Nastepny stan: ", next_state.name)
	return next_state

func _wants_help() -> bool:
	return wants_help

func _has_items_to_unload() -> bool:
	return not npc.inventory.get_items().is_empty()

func _wants_more_items() -> bool:
	return not npc.wanted_products.is_empty()