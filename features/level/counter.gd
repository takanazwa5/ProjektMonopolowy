class_name Counter extends Interactable


@onready var next_item_pos : Marker3D = %NextItemPos


func interact() -> void:

	if Main.player.item_in_hand is not Item:

		return

	Main.player.item_in_hand.reparent(self, false)
	Main.player.item_in_hand.transform = next_item_pos.transform
	Main.player.item_in_hand.collision_layer = 0
	Main.player.item_in_hand.set_script(null)
	Main.player.item_in_hand = null
	next_item_pos.position.x += 0.1
