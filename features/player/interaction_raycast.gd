class_name InteractionRaycast extends RayCast3D


func _process(_delta: float) -> void:

	DebugPanel.add_property(get_collider(), "Collider", 5)


func _unhandled_input(event: InputEvent) -> void:

	if not is_colliding() or not event.is_action_pressed("interact"):

		return

	get_collider().interact()
	get_viewport().set_input_as_handled()
