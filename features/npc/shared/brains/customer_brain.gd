class_name NPCCustomerBrain extends NPCBrain

@onready var entering_store_state: NPCEnteringStoreState = %EnteringStoreState
@onready var waiting_for_product_state: NPCWaitingForProductState = %WaitingForProductState
@onready var paying_state: NPCPayingState = %PayingState
@onready var packing_state: NPCPackingState = %PackingState
@onready var exiting_store_state: NPCExitingStoreState = %ExitingStoreState
@onready var standing_in_queue_state: NPCStandingInQueueState = %StandingInQueueState

func _ready() -> void:
	state_transitions.append_array([
		[entering_store_state, standing_in_queue_state],
		[standing_in_queue_state, waiting_for_product_state],
		[waiting_for_product_state, paying_state],
		[paying_state, packing_state],
		[packing_state, exiting_store_state],
	])
