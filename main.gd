class_name Main extends Node


func _ready() -> void:

	print("Main scene ready.")

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventKey and event.pressed and not event.echo:

		if event.physical_keycode == KEY_ESCAPE:

			get_tree().quit()

		if event.physical_keycode == KEY_BRACKETLEFT:

			if DisplayServer.window_get_mode() == Window.MODE_WINDOWED:

				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

			else:

				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _process(_delta: float) -> void:

	DebugPanel.add_property(Engine.get_frames_per_second(), "FPS", 1000)
