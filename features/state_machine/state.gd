class_name State extends Node


signal finished(new_state: State)


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


func transition(new_state: State) -> void:

	finished.emit(new_state)
