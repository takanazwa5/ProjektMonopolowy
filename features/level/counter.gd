class_name Counter extends Interactable


@onready var next_item_pos : Marker3D = %NextItemPos


func _ready() -> void:

	SignalBus.item_entered_rig.connect(_on_item_entered_rig)
	SignalBus.item_exited_rig.connect(_on_item_exited_rig)


func interact() -> void:

	var item : Item = GameManager.player.item_rig.current_item
	item.reparent(self, false)
	item.transform = next_item_pos.transform
	item.collision_layer = 0
	item.set_script(null)
	next_item_pos.position.x += 0.1


func _on_item_entered_rig() -> void:

	can_interact = true


func _on_item_exited_rig() -> void:

	can_interact = false
