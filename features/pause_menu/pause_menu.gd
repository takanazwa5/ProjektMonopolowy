class_name PauseMenu extends CanvasLayer


signal paused
signal unpaused


var _previous_mouse_mode : Input.MouseMode


@onready var main_pause : VBoxContainer = %MainPause
@onready var resume_button : Button = %ResumeButton
@onready var debug_button : Button = %DebugButton
@onready var quit_button : Button = %QuitButton


func _ready() -> void:

	resume_button.pressed.connect(_on_resume_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	debug_button.pressed.connect(_on_debug_button_pressed)
	DebugMenu.closed.connect(_on_submenu_closed)

	if not OS.is_debug_build():

		debug_button.hide()


func _unhandled_key_input(event: InputEvent) -> void:

	if event.is_action_pressed(&"ui_cancel"):

		if not visible:

			_pause()

		elif main_pause.visible:

			_unpause()


func _pause() -> void:

	show()
	get_tree().paused = true
	_previous_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	paused.emit()


func _unpause() -> void:

	hide()
	get_tree().paused = false
	Input.mouse_mode = _previous_mouse_mode
	unpaused.emit()


func _on_resume_button_pressed() -> void:

	_unpause()


func _on_quit_button_pressed() -> void:

	get_tree().quit()


func _on_debug_button_pressed() -> void:

	main_pause.hide()
	DebugMenu.show()


func _on_submenu_closed() -> void:

	main_pause.show()
