class_name Counter extends Interactable


signal item_placed(item: Item)


var _szlugi_counter: int = 0
var _piwo_counter: int = 0
var _misc_counter: int = 0


@onready var szlugi_targets: Array[Node] = %SzlugiTargets.get_children()
@onready var piwo_targets: Array[Node] = %PiwoTargets.get_children()
@onready var misc_targets: Array[Node] = %MiscTargets.get_children()
@onready var items: Node = %Items


func _ready() -> void:

	SignalBus.item_entered_rig.connect(_on_item_entered_rig)
	SignalBus.item_exited_rig.connect(_on_item_exited_rig)


func interact(event: InputEvent) -> void:

	if not event.is_action_pressed(&"interact"): return
	var item: Item = GameManager.player.item_rig.current_item
	var target: Marker3D
	if item.type == Item.Type.SZLUGI:

		if _szlugi_counter >= 5: return
		target = szlugi_targets[_szlugi_counter]
		_szlugi_counter += 1

	elif item.type == Item.Type.PIWO:

		if _piwo_counter >= 5: return
		target = piwo_targets[_piwo_counter]
		_piwo_counter += 1

	else:

		if _misc_counter >= 5: return
		target = misc_targets[_misc_counter]
		_misc_counter += 1

	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(item, ^"global_transform", target.global_transform, 0.25)
	tween.tween_property(item, ^"rotation_degrees:y", randf_range(-180.0, 180.0), 0.25)
	if item.type == Item.Type.SZLUGI:

		tween.tween_property(item, ^"rotation_degrees:x", item.rotation_degrees.x + 90.0, 0.25)

	item.reparent(items)
	item.can_interact = false
	item_placed.emit(item)


func clear() -> void:

	for child: Node in items.get_children():

		child.queue_free()

	_szlugi_counter = 0
	_piwo_counter = 0
	_misc_counter = 0


func _on_item_entered_rig() -> void:

	can_interact = true


func _on_item_exited_rig() -> void:

	can_interact = false
