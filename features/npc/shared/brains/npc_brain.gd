@abstract
class_name NPCBrain
extends Node

# This array holds possible state transitions for the NPC. Each element is an array containing:
# - state_from: the state from which the transition takes place
# - state_to: the state to which the transition leads
# - condition_func (optional): an optional function that returns a boolean, determining if the transition is possible
# the items should be ordered in the way they are checked,
# the first valid transition, with truthy condition function result or lacking it, will be taken
var state_transitions: Array[Array] = [] # [[state_from, state_to, condition_func], ...]


@onready var npc: NPC = owner

func get_next_state(state: NPCState) -> NPCState:
	for transition in state_transitions:
		var state_from: NPCState = transition[0]
		var state_to: NPCState = transition[1]

		if state_from == state and (transition.size() <= 2 or transition[2].call()):
			return state_to

	push_error("No valid state transition found from state %s in NPC %s!" % [state.name, npc.name])
	return null
