class_name Counter extends Interactable


@onready var next_item_pos : Marker3D = %NextItemPos


func _ready() -> void:

	SignalBus.item_entered_rig.connect(_on_item_entered_rig)
	SignalBus.item_exited_rig.connect(_on_item_exited_rig)


func interact(player: Player) -> void:

	player.item_in_hand.reparent(self, false)
	player.item_in_hand.transform = next_item_pos.transform
	player.item_in_hand.collision_layer = 0
	player.item_in_hand.set_script(null)
	player.item_in_hand = null
	next_item_pos.position.x += 0.1


func _on_item_entered_rig() -> void:

	can_interact = true


func _on_item_exited_rig() -> void:

	can_interact = false
