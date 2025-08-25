class_name Counter extends Interactable


signal item_placed(item: Item)


@onready var next_item_pos: Marker3D = %NextItemPos
@onready var items: Node = %Items


func _ready() -> void:

	SignalBus.item_entered_rig.connect(_on_item_entered_rig)
	SignalBus.item_exited_rig.connect(_on_item_exited_rig)


func interact(event: InputEvent) -> void:

	if not event.is_action_pressed(&"interact"):

		return

	var item: Item = GameManager.player.item_rig.current_item
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(item, ^"global_transform", next_item_pos.global_transform, 0.25)
	item.reparent(items)
	item.collision_layer = 0 # NOTE: To be deleted probably
	item.can_interact = false
	next_item_pos.position.x -= 0.1
	item_placed.emit(item)


func clear() -> void:

	for child: Node in items.get_children():

		child.queue_free()


func _on_item_entered_rig() -> void:

	can_interact = true


func _on_item_exited_rig() -> void:

	can_interact = false
