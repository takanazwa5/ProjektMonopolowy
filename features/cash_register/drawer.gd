class_name CashRegisterDrawer extends Interactable


var open : bool = false


@export var drawer_mesh: Node3D


func interact(event: InputEvent) -> void:

	if not event.is_action_pressed(&"interact"):

		return

	if open:

		_close_drawer()

	else:

		_open_drawer()


func _open_drawer() -> void:

	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(drawer_mesh, ^"position:z", 0.376, 0.25)
	open = true


func _close_drawer() -> void:

	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(drawer_mesh, ^"position:z", 0.126, 0.25)
	open = false
