class_name Trash extends RigidBody3D

signal disposed(trash: Trash)

enum TrashType {
  SOLID,
  LIQUID,
}

@export var trash_type: TrashType = TrashType.SOLID
  
func interact(event: InputEvent, _item_in_hand: Item) -> void:
	if not event.is_action_pressed(&"interact"): return

	if trash_type == TrashType.SOLID:
		disposed.emit(self)
	elif trash_type == TrashType.LIQUID:
		if _item_in_hand != null and _item_in_hand.data.type == ItemData.Type.APPLIANCE and _item_in_hand.data.name == "Mop":
			disposed.emit(self)

			var anim_player: AnimationPlayer = _item_in_hand.get_node_or_null("AnimationPlayer")
			if anim_player != null:
				anim_player.play("USE")
