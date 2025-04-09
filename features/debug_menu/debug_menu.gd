class_name DebugMenu extends Control


signal closed


@onready var window_mode_button : Button = %WindowModeButton
@onready var random_order_button : Button = %RandomOrderButton
@onready var back_button : Button = %BackButton


func _init() -> void:

	GameManager.debug_menu = self


func _ready() -> void:

	window_mode_button.pressed.connect(_on_window_mode_button_pressed)
	back_button.pressed.connect(_close)


func _unhandled_key_input(event: InputEvent) -> void:

	if not visible:

		return

	if event.is_action_pressed(&"ui_cancel"):

		_close()
		accept_event()


func _on_window_mode_button_pressed() -> void:

	var window : Window = get_window()
	if window.mode == Window.MODE_WINDOWED:

		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN

	else:

		window.mode = Window.MODE_WINDOWED


func _close() -> void:

	hide()
	closed.emit()
