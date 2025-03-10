class_name Item extends RigidBody3D


func _ready() -> void:

	if not collision_layer == 0b1000:

		push_warning("%s: Item collision layer is not set to 0b1000." % get_path())


func interact() -> void:

	var copy : Item = duplicate()
	Main.player.item_preview.add_child(copy)
