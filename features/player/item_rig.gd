class_name ItemRig extends Node3D


var current_item: Item


func _ready() -> void:

	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exited_tree)


func _unhandled_key_input(event: InputEvent) -> void:

	if not current_item is Item: return

	if event.is_action_pressed(&"drop_item"):

		current_item.queue_free()
		current_item = null


func _on_child_entered_tree(node: Node) -> void:

	current_item = node
	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(current_item, ^"transform", Transform3D(), 0.25)
	SignalBus.item_entered_rig.emit()


func _on_child_exited_tree(_node: Node) -> void:

	current_item = null
	SignalBus.item_exited_rig.emit()
