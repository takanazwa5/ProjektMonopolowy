class_name ItemPreview extends Node3D


var current_item: Item
var can_rotate: bool = false


@onready var item_rig: Node3D = %ItemRig


func _ready() -> void:

	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exited_tree)
	for item: Item in get_tree().get_nodes_in_group(&"items"):

		item.interaction.connect(_on_item_interaction)


func _unhandled_input(event: InputEvent) -> void:

	if not current_item is Item: return

	if event is InputEventMouseMotion and can_rotate:

		rotate_y(event.relative.x * 0.001)
		rotate_x(event.relative.y * 0.001)

	if event.is_action_pressed(&"interact"): current_item.reparent(item_rig)

	elif event.is_action_pressed(&"drop_item"): current_item.queue_free()


func _on_child_entered_tree(node: Node) -> void:

	get_tree().set_group(&"items", "can_interact", false)
	var item: Item = node
	position.z = clampf(item.preview_zoom, -1.0, -0.15)
	current_item = item
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(current_item, ^"transform", Transform3D(), 0.25)
	if tween.is_running(): await tween.finished
	can_rotate = true


func _on_child_exited_tree(_node: Node) -> void:

	current_item = null
	can_rotate = false
	rotation = Vector3.ZERO
	get_tree().set_group(&"items", "can_interact", true)


func _on_item_interaction(item: Item) -> void:

	add_child(item)
