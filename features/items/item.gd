@tool
class_name Item extends RigidBody3D


signal interaction(item: Item)


@export var data: ItemData


var loose: bool = false


@onready var bottom_marker: Marker3D = %BottomMarker


func interact(event: InputEvent, _item_in_hand: Item) -> void:

	if Engine.is_editor_hint(): return

	if not event.is_action_pressed(&"interact"): return

	if loose: interaction.emit(self)
	else:

		var copy: Item = duplicate()
		interaction.emit(copy)
		copy.global_transform = global_transform
		# NOTE: Might need set_input_as_handled()


func _get_configuration_warnings() -> PackedStringArray:

	var warnings: PackedStringArray = []
	if data.name.is_empty(): warnings.append("Item name is empty.")
	if not is_in_group(&"items"): warnings.append("Not in items group.")
	if not collision_layer & 0b100 == 0b100: warnings.append("Not in items collision layer.")
	return warnings
