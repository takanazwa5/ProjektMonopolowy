@tool
class_name StateMachine extends Node


@export var initial_state : State:

	set(value):

		initial_state = value
		update_configuration_warnings()


@onready var state : State = initial_state


func _ready() -> void:

	if Engine.is_editor_hint(): return
	assert(initial_state is State, "(%s) initial_state property not set." % get_path())

	for child : Node in get_children():

		assert(child is State, "(%s) StateMachine contains incompatible child node." % get_path())
		child.transition.connect(_on_state_transition)

	await owner.ready
	state.enter()


func _unhandled_input(event: InputEvent) -> void:

	if Engine.is_editor_hint(): return
	state.input_event(event)


func _process(delta: float) -> void:

	if Engine.is_editor_hint(): return
	state.update(delta)
	DebugPanel.add_property(state.name, "State", 100)


func _physics_process(delta: float) -> void:

	if Engine.is_editor_hint(): return
	state.physics_update(delta)


func _on_state_transition(new_state: State) -> void:

	if Engine.is_editor_hint(): return
	state.exit()
	state = new_state
	new_state.enter()


func _get_configuration_warnings() -> PackedStringArray:

	if not initial_state is State:

		return ["Initial State must be set."]

	else:

		return []
