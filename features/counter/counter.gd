class_name Counter extends Interactable


signal item_placed(item_data: ItemData)


const TWEEN_DURATION: float = 0.25


var _cigs_counter: int = 0
var _beer_counter: int = 0
var _misc_counter: int = 0


@onready var _cig_targets: Array[Node] = get_tree().get_nodes_in_group(&"cig_targets")
@onready var _beer_targets: Array[Node] = get_tree().get_nodes_in_group(&"beer_targets")
@onready var _misc_targets: Array[Node] = get_tree().get_nodes_in_group(&"_misc_targets")
@onready var _items: Node = %Items


func interact(event: InputEvent, item_in_hand: Item) -> void:

	if not event.is_action_pressed(&"interact"): return

	if is_instance_valid(item_in_hand):

		_place_item_on_counter(item_in_hand)
		can_interact = false


func clear() -> void:

	for child: Node in _items.get_children(): child.queue_free()

	_cigs_counter = 0
	_beer_counter = 0
	_misc_counter = 0


func on_item_entered_rig(_item: Item) -> void:

	can_interact = true


func on_item_exited_rig() -> void:

	can_interact = false


func _move_item_to_target(item: Item, target: Marker3D) -> void:

	target.position.y += absf(item.bottom_marker.position.y)
	target.rotation_degrees.y = randf_range(-180.0, 180.0)
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(item, ^"global_transform", target.global_transform, TWEEN_DURATION)

	#if item.data.type == ItemData.Type.SZLUGI:
#
		#tween.tween_property(item, ^"rotation_degrees:x", 90.0, TWEEN_DURATION).as_relative()

	if tween.is_running(): await tween.finished
	target.position.y -= absf(item.bottom_marker.position.y)


func _place_item_on_counter(item: Item) -> void:

	var target: Marker3D
	if item.data.type == ItemData.Type.SZLUGI:

		if _cigs_counter >= _cig_targets.size(): return
		target = _cig_targets[_cigs_counter]
		_cigs_counter += 1

	elif item.data.type == ItemData.Type.PIWO:

		if _beer_counter >= _beer_targets.size(): return
		target = _beer_targets[_beer_counter]
		_beer_counter += 1

	elif item.data.type == ItemData.Type.MISC:

		if _misc_counter >= _misc_targets.size(): return
		target = _misc_targets[_misc_counter]
		_misc_counter += 1

	await _move_item_to_target(item, target)
	item_placed.emit(item.data)
	item.reparent(_items)
	item.set_script(null)
