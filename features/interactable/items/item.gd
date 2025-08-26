@tool
class_name Item extends Interactable


enum Type {SZLUGI, PIWO, MISC}


@export_range(-1.0, -0.15, 0.01) var preview_zoom: float = -0.15
@export var item_name: String = ""
@export var type: Type = Type.MISC


static var _names: PackedStringArray = []


func _init() -> void:

	if Engine.is_editor_hint(): return

	if not item_name.is_empty():

		assert(item_name not in _names, "Duplicate item names: %s" % item_name)
		_names.append(item_name)


func interact(event: InputEvent) -> void:

	if Engine.is_editor_hint(): return

	if not event.is_action_pressed(&"interact"):

		return

	var copy : Item = duplicate()
	GameManager.player.item_preview.add_child(copy)
	copy.global_transform = global_transform
	# NOTE: Might need set_input_as_handled()


func _get_configuration_warnings() -> PackedStringArray:

	var warnings: PackedStringArray = []
	if item_name.is_empty(): warnings.append("Item Name is empty.")
	if reticle_tooltip_text.is_empty(): warnings.append("Reticle Tooltip Text is empty.")
	if not is_in_group(&"items"): warnings.append("Not in items group.")
	if not collision_layer & 0b100 == 0b100: warnings.append("Not in items collision layer.")
	return warnings
