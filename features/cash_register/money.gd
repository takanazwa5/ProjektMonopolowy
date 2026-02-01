class_name Money extends StaticBody3D


signal interaction(money: Money, interaction_sign: int)

enum BILL_TYPE {COIN, NOTE}

const ADD_SIGN: int = 1
const SUBTRACT_SIGN: int = -1

@export var value: float = 0.0
@export var bill_type: BILL_TYPE = BILL_TYPE.NOTE


func interact(event: InputEvent, _item_in_hand: Item) -> void:
	if not (event is InputEventMouseButton and event.is_pressed()):
		return

	if event.button_index == MOUSE_BUTTON_LEFT:
		interaction.emit(self, ADD_SIGN)

	elif event.button_index == MOUSE_BUTTON_RIGHT:
		interaction.emit(self, SUBTRACT_SIGN)
