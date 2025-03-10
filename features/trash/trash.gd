class_name Trash extends Interactable


func _ready() -> void:

	SignalBus.item_entered_rig.connect(_on_item_entered_rig)
	SignalBus.item_exited_rig.connect(_on_item_exited_rig)

	if not collision_layer == 0b100:

		push_warning("%s: Trash collision layer is not set to 0b100." % get_path())


func interact() -> void:

	queue_free()


func _on_item_entered_rig() -> void:

	can_interact = false


func _on_item_exited_rig() -> void:

	can_interact = true
