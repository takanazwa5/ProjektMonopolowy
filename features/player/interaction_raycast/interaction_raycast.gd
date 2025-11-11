class_name InteractionRaycast extends RayCast3D


signal collider_changed(collider: Object)


@export var item_preview: ItemPreview
@export var item_rig: ItemRig


var _collider: Object
var _last_frame_collider: Object


func _ready() -> void:

	item_preview.item_entered.connect(_on_item_entered_preview)
	item_preview.item_exited.connect(_on_item_exited_preview)


func _unhandled_input(event: InputEvent) -> void:

	if not is_instance_valid(_collider): return

	if _collider is Interactable and _collider.can_interact:

		_collider.interact(event, item_rig.current_item)

	elif _collider is NPC:

		if _collider.has_method("interact"): _collider.interact(event)


func _process(_delta: float) -> void:

	_last_frame_collider = _collider
	_collider = get_collider()
	if not _collider == _last_frame_collider: collider_changed.emit(_collider)
	DebugPanel.add_property(_collider, "collider", 50)


func _on_item_entered_preview(_item: Item) -> void:

	enabled = false


func _on_item_exited_preview() -> void:

	enabled = true
