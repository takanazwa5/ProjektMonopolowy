class_name Item extends RigidBody3D


@export var rig_position : Vector3


func _ready() -> void:

	if not collision_layer == 0b1000:

		push_warning("%s: Item collision layer is not set to 0b1000." % get_path())


func interact() -> void:

	reparent(Main.player.item_rig, false)
	position = rig_position
	rotation = Vector3.ZERO
	freeze = true
	Main.player.item_in_hand = self
