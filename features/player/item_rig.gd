class_name ItemRig extends Node3D


signal item_entered(item: Item)
signal item_exited()


const TWEEN_DURATION: float = 0.25


var current_item: Item


func _ready() -> void:

	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exited_tree)


func _unhandled_key_input(event: InputEvent) -> void:

	if not is_instance_valid(current_item): return

	if event.is_action_pressed(&"drop_item"): current_item.queue_free()


func _move_item_to_rig(item: Item) -> void:

	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(item, ^"transform", Transform3D(), TWEEN_DURATION)


func _on_child_entered_tree(node: Node) -> void:

	current_item = node
	_move_item_to_rig(current_item)
	get_tree().set_group(&"items", "can_interact", false)
	item_entered.emit(current_item)


func _on_child_exited_tree(_node: Node) -> void:

	current_item = null
	get_tree().set_group(&"items", "can_interact", true)
	item_exited.emit()
