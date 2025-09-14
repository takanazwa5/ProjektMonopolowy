class_name ItemPreview extends Node3D


signal item_entered(item: Item)
signal item_exited()


const TWEEN_DURATION: float = 0.25


var _current_item: Item
var _original_global_transform: Transform3D
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

	if event.is_action_pressed(&"interact"):

		if not _current_item.loose: _current_item.interaction.connect(_on_item_interaction)
		_current_item.reparent(item_rig)
		get_viewport().set_input_as_handled()

	elif event.is_action_pressed(&"drop_item"):

		if _current_item.loose:

			_current_item.global_transform = _original_global_transform
			_current_item.freeze = false
			var game: Game = get_tree().current_scene
			_current_item.reparent(game.loose_items)

		else: _current_item.queue_free()


func _move_item_to_preview(item: Item) -> void:

	_original_global_transform = item.global_transform
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(item, ^"transform", Transform3D(), TWEEN_DURATION)
	if tween.is_running(): await tween.finished


func _on_child_entered_tree(node: Node) -> void:

	_current_item = node
	#print("item entering preview: %s" % _current_item)
	item_entered.emit(_current_item)
	_current_item.freeze = true
	position.z = clampf(_current_item.data.preview_zoom, -1.0, -0.15)
	await _move_item_to_preview(_current_item)
	_can_rotate = true


func _on_child_exited_tree(_node: Node) -> void:

	#print("item exiting preview: %s" % _current_item)
	item_exited.emit()
	_current_item = null
	_can_rotate = false
	rotation = Vector3.ZERO


func _on_item_interaction(item: Item) -> void:

	if item.loose: item.reparent(self)
	else: add_child(item)
