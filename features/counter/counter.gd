class_name Counter extends StaticBody3D


signal product_placed(product_data: ProductData)


const TWEEN_DURATION: float = 0.25


static var instance: Counter

var _cigs_counter: int = 0
var _beer_counter: int = 0
var _misc_counter: int = 0
var _npc_at_counter: NPC = null
var _player_has_item_in_hand: bool = false
var _is_customer_waiting_for_product: bool = false

var npc_at_counter: NPC = null:
	set(value):
		_npc_at_counter = value
		_is_customer_waiting_for_product = (value != null)
	get:
		return _npc_at_counter

var player_has_item_in_hand: bool:
	get:
		return _player_has_item_in_hand
	set(value):
		_player_has_item_in_hand = value
		set_meta(&"can_interact", value and _is_customer_waiting_for_product)

var is_customer_waiting_for_product: bool:
	get:
		return _is_customer_waiting_for_product
	set(value):
		_is_customer_waiting_for_product = value
		set_meta(&"can_interact", value and _player_has_item_in_hand)

@onready var _cig_targets: Array[Node] = get_tree().get_nodes_in_group(&"cig_targets")
@onready var _beer_targets: Array[Node] = get_tree().get_nodes_in_group(&"beer_targets")
@onready var _misc_targets: Array[Node] = get_tree().get_nodes_in_group(&"_misc_targets")
@onready var _items: Node = %Items

func _init() -> void:
	instance = self


func interact(event: InputEvent, item_in_hand: Item) -> void:
	if not event.is_action_pressed(&"interact"):
		return

	if not _is_placeable_product_item(item_in_hand):
		return

	if not _can_place_player_item(item_in_hand.data):
		return

	_place_item_on_counter(item_in_hand)
	# set_meta(&"can_interact", false)


func place_item_from_npc(item_in_hand: Item) -> void:
	if not _is_placeable_product_item(item_in_hand):
		return

	_place_item_on_counter(item_in_hand)


func _is_placeable_product_item(item_in_hand: Item) -> bool:
	if not is_instance_valid(item_in_hand):
		return false

	return item_in_hand.data is ProductData


func _can_place_player_item(product_data: ProductData) -> bool:
	if not _is_player_interaction_allowed():
		return false

	return npc_at_counter.wanted_products.has(product_data.name)


func _is_player_interaction_allowed() -> bool:
	return is_instance_valid(npc_at_counter) and npc_at_counter.wants_more_items()


func clear() -> void:

	for child: Node in _items.get_children(): child.queue_free()

	_cigs_counter = 0
	_beer_counter = 0
	_misc_counter = 0


func on_item_entered_rig(_item: Item) -> void:
	player_has_item_in_hand = true


func on_item_exited_rig() -> void:
	player_has_item_in_hand = false


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

	var product_data: ProductData = item.data
	var target: Marker3D
	if product_data.type == ItemData.Type.SZLUGI:

		if _cigs_counter >= _cig_targets.size(): return
		target = _cig_targets[_cigs_counter]
		_cigs_counter += 1

	elif product_data.type == ItemData.Type.PIWO or product_data.type == ItemData.Type.WINO:
		if _beer_counter >= _beer_targets.size(): return
		target = _beer_targets[_beer_counter]
		_beer_counter += 1

	elif product_data.type == ItemData.Type.MISC:

		if _misc_counter >= _misc_targets.size(): return
		target = _misc_targets[_misc_counter]
		_misc_counter += 1

	else: return

	item.remove_meta(&"can_interact")
	item.remove_meta(&"reticle_tooltip")

	await _move_item_to_target(item, target)
	product_placed.emit(product_data)
	item.reparent(_items)
