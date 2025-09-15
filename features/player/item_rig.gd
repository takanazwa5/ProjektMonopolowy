class_name ItemRig extends Node3D


signal item_entered(item: Item)
signal item_exited()


const TWEEN_DURATION: float = 0.25
const YEET_FORCE: float = 5.0


var current_item: Item
var _original_position: Vector3 = position


func _ready() -> void:

	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exited_tree)


func _unhandled_input(event: InputEvent) -> void:

	if not is_instance_valid(current_item): return

	if event.is_action_pressed(&"drop_item"):

		var game: Game = get_tree().current_scene
		current_item.freeze = false
		current_item.apply_impulse(-get_viewport().get_camera_3d().global_basis.z)
		current_item.reparent(game.loose_items)

	elif event.is_action_pressed(&"yeet_item"):

		var game: Game = get_tree().current_scene
		current_item.freeze = false
		current_item.apply_impulse(-get_viewport().get_camera_3d().global_basis.z * YEET_FORCE)
		current_item.reparent(game.loose_items)


func _move_item_to_rig(item: Item) -> void:

	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(item, ^"transform", Transform3D(), TWEEN_DURATION)


func _on_child_entered_tree(node: Node) -> void:

	current_item = node
	#print("item entering rig: %s" % current_item)
	item_entered.emit(current_item)
	position += current_item.data.rig_position
	current_item.loose = true
	_move_item_to_rig(current_item)
	get_tree().set_group(&"items", "can_interact", false)


func _on_child_exited_tree(_node: Node) -> void:

	#print("item exiting rig: %s" % current_item)
	item_exited.emit()
	position = _original_position
	current_item = null
	get_tree().set_group(&"items", "can_interact", true)
