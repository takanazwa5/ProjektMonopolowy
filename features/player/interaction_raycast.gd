class_name InteractionRaycast extends RayCast3D


var collider : Object


func _unhandled_key_input(event: InputEvent) -> void:

	if event.is_action_pressed(&"interact"):

		if collider is Interactable and collider.can_interact:

			collider.interact()


func _process(_delta: float) -> void:

	collider = get_collider()
	DebugPanel.add_property(collider, "collider", 50)
