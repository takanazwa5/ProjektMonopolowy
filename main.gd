class_name Main extends Node


func _ready() -> void:

	print("main scene loaded")


func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventKey and event.pressed and not event.echo:

		if event.physical_keycode == KEY_ESCAPE:

			get_tree().quit()
