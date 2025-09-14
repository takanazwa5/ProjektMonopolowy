class_name InteractionRaycast extends RayCast3D


var collider: Object


@onready var item_preview: ItemPreview = %ItemPreview
@onready var item_rig: ItemRig = %ItemRig


func _ready() -> void:

	item_preview.item_entered.connect(_on_item_entered_preview)
	item_preview.item_exited.connect(_on_item_exited_preview)


func _unhandled_input(event: InputEvent) -> void:

	if not is_instance_valid(collider): return

	if collider is Interactable:

		if collider.can_interact: collider.interact(event, item_rig.current_item)


func _process(_delta: float) -> void:

	collider = get_collider()
	DebugPanel.add_property(collider, "collider", 50)


func _on_item_entered_preview(_item: Item) -> void:

	enabled = false


func _on_item_exited_preview() -> void:

	enabled = true
