class_name Basia extends NPC


func _unhandled_input(_event: InputEvent) -> void:

	if Input.is_key_pressed(KEY_KP_1):

		navigate_to_node(Level.fridge)

	elif Input.is_key_pressed(KEY_KP_2):

		navigate_to_node(Level.counter)
