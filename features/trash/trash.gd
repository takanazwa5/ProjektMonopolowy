class_name Trash extends Interactable


func _ready() -> void:

	SignalBus.item_entered_rig.connect(_on_item_entered_rig)
	SignalBus.item_exited_rig.connect(_on_item_exited_rig)


func interact(event: InputEvent) -> void:

	if not event.is_action_pressed(&"interact"):

		return

	queue_free()


func _on_item_entered_rig() -> void:

	can_interact = false


func _on_item_exited_rig() -> void:

	can_interact = true
