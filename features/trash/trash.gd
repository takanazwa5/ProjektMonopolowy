class_name Trash extends Interactable


func _ready() -> void:

	SignalBus.item_entered_rig.connect(_on_item_entered_rig)
	SignalBus.item_exited_rig.connect(_on_item_exited_rig)


func interact() -> void:

	queue_free()


func _on_item_entered_rig() -> void:

	can_interact = false


func _on_item_exited_rig() -> void:

	can_interact = true
