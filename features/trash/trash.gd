class_name Trash extends RigidBody3D

signal disposed(trash: Trash)

enum TrashType {
  SOLID,
  LIQUID,
}

@export var trash_type: TrashType = TrashType.SOLID
  
func interact(event: InputEvent, item_in_hand: Item) -> void:
	if not event.is_action_pressed(&"interact"): return

	if trash_type == TrashType.SOLID:
		disposed.emit(self)

	elif trash_type == TrashType.LIQUID:
		if is_instance_valid(item_in_hand) and item_in_hand.data.type == ItemData.Type.APPLIANCE and item_in_hand.data.name == "Mop":
			disposed.emit(self)

			var anim_player: AnimationPlayer = item_in_hand.get_node_or_null("AnimationPlayer")
			if is_instance_valid(anim_player):
				anim_player.play("USE")
