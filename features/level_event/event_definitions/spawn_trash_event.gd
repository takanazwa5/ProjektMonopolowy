class_name SpawnTrashEvent
extends LevelEvent

func execute_event() -> void:
  if Level.instance == null: return

  Level.instance.trash_container.spawn_trash(1)