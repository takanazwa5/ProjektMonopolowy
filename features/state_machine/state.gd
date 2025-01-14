class_name State extends Node


signal transition(new_state: State)


func enter() -> void:

	pass


func input_event(_event: InputEvent) -> void:

	pass


func update(_delta: float) -> void:

	pass


func physics_update(_delta: float) -> void:

	pass


func exit() -> void:

	pass


func transition_to(new_state: State) -> void:

	transition.emit(new_state)
