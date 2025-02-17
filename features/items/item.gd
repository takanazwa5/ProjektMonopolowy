class_name Item extends RigidBody3D


var origin : Transform3D


func _ready() -> void:

	if not collision_layer == 0b1000:

		push_warning("%s: Item collision layer is not set to 0b1000." % get_path())


func interact() -> void:

	origin = global_transform
	reparent(Main.player.item_preview)
	transform = Transform3D()
	freeze = true
	Main.player.item_in_preview = self
	Main.player.interaction_raycast.enabled = false
	Main.player.can_move_camera = false
	Main.player.can_move = false
