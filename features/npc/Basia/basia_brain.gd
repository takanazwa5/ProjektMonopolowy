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
	state_transitions.append_array([
		[entering_store_state, getting_product_state],
		[getting_product_state, standing_in_queue_state],
		[standing_in_queue_state, unloading_products_on_counter_state, npc.has_items_to_unload],
		[standing_in_queue_state, waiting_for_product_state],
		[unloading_products_on_counter_state, waiting_for_product_state, npc.wants_more_items],
		[unloading_products_on_counter_state, paying_state],
		[waiting_for_product_state, paying_state],
		[paying_state, packing_state],
		[packing_state, exiting_store_state],
	])