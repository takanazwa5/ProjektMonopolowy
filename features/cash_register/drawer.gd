class_name CashRegisterDrawer extends StaticBody3D


var open : bool = false


func open_drawer() -> void:

	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, ^"position:z", 0.25, 0.25)
	open = true
	for node : Money in get_tree().get_nodes_in_group(&"Cash"):

		node.can_interact = true


func close_drawer() -> void:

	var tween : Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, ^"position:z", 0.0, 0.25)
	open = false
	for node : Money in get_tree().get_nodes_in_group(&"Cash"):

		node.can_interact = false
