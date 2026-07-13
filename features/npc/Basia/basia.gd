class_name Basia extends NPC


func interact(event: InputEvent) -> void:
	if not event.is_action_pressed(&"interact"):
		return

	interaction.emit("npc_basia_001")
