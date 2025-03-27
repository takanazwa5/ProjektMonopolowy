class_name ItemPreview extends Node3D


var current_item : Item


@onready var item_preview_prompt : Control = %ItemPreviewPrompt
@onready var item_rig : Node3D = %ItemRig


func _ready() -> void:

	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exited_tree)


func _unhandled_input(event: InputEvent) -> void:

	if not current_item is Item:

		return

	if event is InputEventMouseMotion:

		rotate_y(event.relative.x * 0.001)
		rotate_x(event.relative.y * 0.001)


func _unhandled_key_input(event: InputEvent) -> void:

	if not current_item is Item:

		return

	if event.is_action_pressed(&"interact"):

		current_item.rotation = Vector3.ZERO
		current_item.reparent(item_rig, false)

	elif event.is_action_pressed(&"drop_item"):

		current_item.queue_free()


func _on_child_entered_tree(node: Node) -> void:

	if not node is Item:

		push_error("Node entered item preview is not item")
		return

	current_item = node
	current_item.transform = Transform3D()
	GameManager.player.can_move = false
	GameManager.player.can_move_camera = false
	item_preview_prompt.show()
	SignalBus.item_entered_preview.emit()


func _on_child_exited_tree(_node: Node) -> void:

	current_item = null
	GameManager.player.can_move = true
	GameManager.player.can_move_camera = true
	item_preview_prompt.hide()
	rotation = Vector3.ZERO
	SignalBus.item_exited_preview.emit()
