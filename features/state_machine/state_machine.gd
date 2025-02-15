class_name StateMachine extends Node


@export var initial_state : State


@onready var state : State = initial_state


func _ready() -> void:

	assert(initial_state is State, "(%s) initial_state property not set." % get_path())

	for child : Node in get_children():

		assert(child is State, "(%s) StateMachine contains incompatible child node." % get_path())
		child.transition.connect(_on_state_transition)

	await owner.ready
	state.enter()


func _unhandled_input(event: InputEvent) -> void:

	state.input_event(event)


func _process(delta: float) -> void:

	state.update(delta)
	DebugPanel.add_property(state.name, "State", 4)


func _physics_process(delta: float) -> void:

	state.physics_update(delta)


func _on_state_transition(new_state: State) -> void:

	state.exit()
	state = new_state
	new_state.enter()
