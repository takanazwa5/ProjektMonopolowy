class_name Item extends Interactable


@export_range(-1.0, -0.15, 0.01) var preview_zoom: float = -0.15
@export var item_name: String = ""


static var _names: PackedStringArray = []


func _init() -> void:

	if not item_name.is_empty():

		assert(item_name not in _names, "Duplicate item names: %s" % item_name)
		_names.append(item_name)


func _ready() -> void:

	SignalBus.item_entered_preview.connect(_on_item_entered_preview)
	SignalBus.item_exited_preview.connect(_on_item_exited_preview)
	SignalBus.item_entered_rig.connect(_on_item_entered_rig)
	SignalBus.item_exited_rig.connect(_on_item_exited_rig)


func interact(event: InputEvent) -> void:

	if not event.is_action_pressed(&"interact"):

		return

	var copy : Item = duplicate()
	GameManager.player.item_preview.add_child(copy)
	copy.global_transform = global_transform
	# NOTE: Might need set_input_as_handled()


func _on_item_entered_preview() -> void:

	can_interact = false


func _on_item_exited_preview() -> void:

	can_interact = true


func _on_item_entered_rig() -> void:

	can_interact = false


func _on_item_exited_rig() -> void:

	can_interact = true
