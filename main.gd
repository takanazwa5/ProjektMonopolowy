class_name Main extends Node


func _ready() -> void:

	print("Main scene ready.")


func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventKey and event.pressed and not event.echo:

		if event.physical_keycode == KEY_ESCAPE:

			get_tree().quit()


func _process(_delta: float) -> void:

	DebugPanel.add_property(Engine.get_frames_per_second(), "FPS", 1)
