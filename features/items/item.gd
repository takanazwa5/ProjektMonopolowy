class_name Item extends RigidBody3D


func _ready() -> void:

	if not collision_layer == 0b1000:

		push_warning("%s: Item collision layer is not set to 0b1000." % get_path())


func interact() -> void:

	reparent(Main.player.get_node("%ItemRig"), false)
	position = Vector3(0.125, -0.275, -0.215)
	freeze = true
	Main.player.item_in_hand = self
