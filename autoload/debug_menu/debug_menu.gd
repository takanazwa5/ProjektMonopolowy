extends CanvasLayer


signal closed


@onready var buttons_container: VBoxContainer = %ButtonsContainer
@onready var back_button : Button = %BackButton


func _ready() -> void:

	back_button.pressed.connect(_on_back_button_pressed)


func _unhandled_key_input(event: InputEvent) -> void:

	if not visible: return

	if event.is_action_pressed(&"ui_cancel"):

		_close()
		get_viewport().set_input_as_handled()


func _close() -> void:

	hide()
	closed.emit()


func add_button(callable: Callable) -> void:

	var button: Button = Button.new()
	button.text = "%s.%s" % [callable.get_object().get_class(), callable.get_method()]
	button.pressed.connect(callable)
	buttons_container.add_child(button)
	buttons_container.move_child(button, 0)


func _on_back_button_pressed() -> void:

	_close()
