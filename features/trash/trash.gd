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
    emit_signal("disposed", self)
  elif trash_type == TrashType.LIQUID:
    if _item_in_hand != null and _item_in_hand.data.name == "Mop":
      emit_signal("disposed", self)
      
      if _item_in_hand.get_node("AnimationPlayer") != null:
        var anim_player: AnimationPlayer = _item_in_hand.get_node("AnimationPlayer")
        anim_player.play("USE")
