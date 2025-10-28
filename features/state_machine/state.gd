@abstract class_name State extends Node


@warning_ignore("unused_signal")
signal transition(new_state: State)


@abstract func enter() -> void

@abstract func input_event(_event: InputEvent) -> void

@abstract func update(_delta: float) -> void

@abstract func physics_update(_delta: float) -> void

@abstract func exit() -> void
