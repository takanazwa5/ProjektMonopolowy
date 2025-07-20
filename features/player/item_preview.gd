class_name ItemPreview extends Node3D


var current_item : Item
var can_rotate: bool = false


@onready var item_rig : Node3D = %ItemRig


func _ready() -> void:

	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exited_tree)


func _unhandled_input(event: InputEvent) -> void:

	if not current_item is Item:

		return

	if event is InputEventMouseMotion and can_rotate:

		rotate_y(event.relative.x * 0.001)
		rotate_x(event.relative.y * 0.001)


func _unhandled_key_input(event: InputEvent) -> void:

	if not current_item is Item:

		return

	if event.is_action_pressed(&"interact"):

		#current_item.rotation = Vector3.ZERO
		var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(current_item, ^"transform", Transform3D(), 0.25)
		current_item.reparent(item_rig)

	elif event.is_action_pressed(&"drop_item"):

		current_item.queue_free()


func _on_child_entered_tree(node: Node) -> void:

	assert(node is Item)
	position.z = clampf(node.preview_zoom, -1.0, -0.15)
	current_item = node
	#current_item.transform = Transform3D()
	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(current_item, ^"transform", Transform3D(), 0.25)
	GameManager.player.can_move = false
	GameManager.player.can_move_camera = false
	SignalBus.item_entered_preview.emit()
	if tween.is_running(): await tween.finished
	can_rotate = true


func _on_child_exited_tree(_node: Node) -> void:

	current_item = null
	GameManager.player.can_move = true
	GameManager.player.can_move_camera = true
	can_rotate = false
	rotation = Vector3.ZERO
	SignalBus.item_exited_preview.emit()
