class_name Item extends Interactable


const TARGET_COLLISION_LAYER : int = 0b1000


func _ready() -> void:

	SignalBus.item_entered_preview.connect(_on_item_entered_preview)
	SignalBus.item_exited_preview.connect(_on_item_exited_preview)
	SignalBus.item_entered_rig.connect(_on_item_entered_rig)
	SignalBus.item_exited_rig.connect(_on_item_exited_rig)

	if not collision_layer == TARGET_COLLISION_LAYER:

		push_warning("%s: Item collision layer is not set to 0b1000." % get_path())


func interact() -> void:

	var copy : StaticBody3D = duplicate(0)
	copy.collision_layer = 0
	Main.player.item_preview.add_child(copy)
	get_viewport().set_input_as_handled()


func _on_item_entered_preview() -> void:

	can_interact = false


func _on_item_exited_preview() -> void:

	can_interact = true


func _on_item_entered_rig() -> void:

	can_interact = false


func _on_item_exited_rig() -> void:

	can_interact = true
