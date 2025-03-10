class_name Item extends Interactable


const TARGET_COLLISION_LAYER : int = 0b1000


func _ready() -> void:

	if not collision_layer == TARGET_COLLISION_LAYER:

		push_warning("%s: Item collision layer is not set to 0b1000." % get_path())


func interact() -> void:

	if Main.player.item_in_hand is Item or Main.player.item_in_preview is Item:

		return

	var copy : Item = duplicate()
	Main.player.item_preview.add_child(copy)
	get_viewport().set_input_as_handled()
