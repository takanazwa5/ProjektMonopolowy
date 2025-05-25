class_name Counter extends Interactable


@onready var next_item_pos : Marker3D = %NextItemPos


func _ready() -> void:

	SignalBus.item_entered_rig.connect(_on_item_entered_rig)
	SignalBus.item_exited_rig.connect(_on_item_exited_rig)


func interact(event: InputEvent) -> void:

	if not event.is_action_pressed(&"interact"):

		return

	var item : Item = GameManager.player.item_rig.current_item
	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(item, ^"transform", next_item_pos.transform, 0.25)
	item.reparent(self)
	item.collision_layer = 0
	item.set_script(null)
	next_item_pos.position.x -= 0.1


func _on_item_entered_rig() -> void:

	can_interact = true


func _on_item_exited_rig() -> void:

	can_interact = false
