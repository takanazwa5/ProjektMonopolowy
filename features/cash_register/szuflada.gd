class_name CashRegisterDrawer extends Interactable


var open : bool = false


func interact() -> void:

	if open:

		_close_drawer()

	else:

		_open_drawer()


func _open_drawer() -> void:

	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, ^"position:z", 0.25, 0.25)
	open = true


func _close_drawer() -> void:

	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, ^"position:z", 0.0, 0.25)
	open = false
