@tool
class_name StateMachine extends Node


@export var initial_state : State:

	set(value):

		initial_state = value
		update_configuration_warnings()


var current_state : State


func _ready() -> void:

	if Engine.is_editor_hint(): return
	assert(initial_state is State, "(%s) initial_state property not set." % get_path())

	for child : Node in get_children():

		if not child is State:

			push_warning("(%s) State Machine contains incompatible child node." % get_path())
			update_configuration_warnings()
			continue

		child.transition.connect(_on_state_transition)

	await owner.ready
	current_state = initial_state
	current_state.enter()


func _unhandled_input(event: InputEvent) -> void:

	if Engine.is_editor_hint(): return
	current_state.input_event(event)


func _process(delta: float) -> void:

	if Engine.is_editor_hint(): return
	current_state.update(delta)
	DebugPanel.add_property(current_state.name, "State", 100)


func _physics_process(delta: float) -> void:

	if Engine.is_editor_hint(): return
	current_state.physics_update(delta)


func _on_state_transition(new_state: State) -> void:

	if Engine.is_editor_hint(): return
	current_state.exit()
	current_state = new_state
	new_state.enter()


func _get_configuration_warnings() -> PackedStringArray:

	var warnings: PackedStringArray = []
	if not initial_state is State: warnings.append("Initial State must be set.")
	for child: Node in get_children():

		if not child is State:

			warnings.append("State Machine contains incompatible child node.")
			break

	return warnings
