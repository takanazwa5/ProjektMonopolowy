class_name Trash extends StaticBody3D


func _ready() -> void:

	if not collision_layer == 0b100:

		push_warning("%s: Trash collision layer is not set to 0b100." % get_path())


func interact() -> void:

	queue_free()
