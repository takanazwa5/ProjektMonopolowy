class_name Money extends Interactable


signal interaction(value: float)


@export var value : float = 0.0


func interact(event: InputEvent, _item_in_hand: Item) -> void:

	if not (event is InputEventMouseButton and event.is_pressed()):

		return

	if event.button_index == MOUSE_BUTTON_LEFT:

		interaction.emit(value)

	elif event.button_index == MOUSE_BUTTON_RIGHT:

		interaction.emit(-value)
