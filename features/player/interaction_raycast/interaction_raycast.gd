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
	if not _collider.get_meta(&"can_interact", false): return
	if not _collider.has_method(&"interact"): return

	var arg_count: int = _collider.get_method_argument_count(&"interact")
	if arg_count == 1: _collider.call(&"interact", event)
	elif  arg_count == 2: _collider.call(&"interact", event, item_rig.current_item)


func _process(_delta: float) -> void:

	_last_frame_collider = _collider
	_collider = get_collider()
	if not _collider == _last_frame_collider: collider_changed.emit(_collider)
	DebugPanel.add_property(_collider, "collider", 50)


func _on_item_entered_preview(_item: Item) -> void:

	enabled = false


func _on_item_exited_preview() -> void:

	enabled = true
