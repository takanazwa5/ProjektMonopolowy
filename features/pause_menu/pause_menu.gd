class_name PauseMenu extends Control


signal paused
signal unpaused


var _previous_mouse_mode : Input.MouseMode


@onready var resume_button : Button = %ResumeButton
@onready var quit_button : Button = %QuitButton


func _init() -> void:

	GameManager.pause_menu = self


func _ready() -> void:

	resume_button.pressed.connect(_on_resume_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _unhandled_key_input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_cancel"):

		if not visible:

			_pause()

		else:

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
