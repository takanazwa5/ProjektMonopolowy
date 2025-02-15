class_name Interactable extends CollisionObject3D


@export var can_interact : bool = true


func _ready() -> void:

	if not collision_layer == 0b100:

		push_warning("%s: Trash collision layer is not set to 0b100." % get_path())


func interact() -> void:

	pass
