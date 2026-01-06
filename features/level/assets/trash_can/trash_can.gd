class_name TrashCan extends StaticBody3D

signal interacted

@onready var bin_insides: Area3D = %BinInsides

func _ready() -> void:
  bin_insides.body_entered.connect(_on_item_entered_bin)

func interact(event: InputEvent) -> void:
  if not event.is_action_pressed(&"interact"): return
  interacted.emit()

func _on_item_entered_bin(item: Node) -> void:
  if item is Item and item.data.is_disposable:
    item.queue_free()
