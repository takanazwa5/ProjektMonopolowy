class_name ItemPreview extends Node3D


signal item_entered(item: Item)
signal item_exited()


var _current_item: Item
var _can_rotate: bool = false


@onready var item_rig: Node3D = %ItemRig


func _ready() -> void:

	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exited_tree)
	for item: Item in get_tree().get_nodes_in_group(&"items"):

		item.interaction.connect(_on_item_interaction)


func _unhandled_input(event: InputEvent) -> void:

	if not is_instance_valid(_current_item): return

	if event is InputEventMouseMotion and _can_rotate:

		rotate_y(event.relative.x * 0.001)
		rotate_x(event.relative.y * 0.001)

	if event.is_action_pressed(&"interact"): _current_item.reparent(item_rig)
	elif event.is_action_pressed(&"drop_item"): _current_item.queue_free()


func _on_child_entered_tree(node: Node) -> void:

	_current_item = node
	position.z = clampf(_current_item.data.preview_zoom, -1.0, -0.15)
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(_current_item, ^"transform", Transform3D(), 0.25)
	if tween.is_running(): await tween.finished
	_can_rotate = true
	item_entered.emit(_current_item)


func _on_child_exited_tree(_node: Node) -> void:

	_can_rotate = false
	rotation = Vector3.ZERO
	item_exited.emit()


func _on_item_interaction(item: Item) -> void:

	add_child(item)
