@tool
class_name Item extends Interactable


signal interaction(item_data: ItemData)


@export var data: ItemData


@onready var bottom_marker: Marker3D = %BottomMarker


func interact(event: InputEvent) -> void:

	if Engine.is_editor_hint(): return

	if not event.is_action_pressed(&"interact"): return

	var copy : Item = duplicate(0)
	interaction.emit(data)
	copy.global_transform = global_transform
	# NOTE: Might need set_input_as_handled()


func _get_configuration_warnings() -> PackedStringArray:

	var warnings: PackedStringArray = []
	if data.name.is_empty(): warnings.append("Item name is empty.")
	if reticle_tooltip_text.is_empty(): warnings.append("Reticle Tooltip Text is empty.")
	if not is_in_group(&"items"): warnings.append("Not in items group.")
	if not collision_layer & 0b100 == 0b100: warnings.append("Not in items collision layer.")
	return warnings
