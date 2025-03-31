class_name Baknote extends Interactable


func interact(event: InputEvent) -> void:

	if not (event is InputEventMouseButton and event.is_pressed()):

		return

	if event.button_index == MOUSE_BUTTON_LEFT:

		print("lmb")

	elif event.button_index == MOUSE_BUTTON_RIGHT:

		print("rmb")
