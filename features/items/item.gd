class_name Item extends RigidBody3D


var origin : Transform3D


func _ready() -> void:

	if not collision_layer == 0b1000:

		push_warning("%s: Item collision layer is not set to 0b1000." % get_path())


func interact() -> void:

	origin = global_transform
	reparent(Main.player.item_preview, false)
