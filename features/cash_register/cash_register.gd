class_name CashRegister extends Node3D


@export var drawer : StaticBody3D
@export var drawer_open_final_pos_z : float
@export var drawer_closed_final_pos_z : float


var open : bool = false


func _open_drawer() -> void:

	var tween : Tween = drawer.create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(drawer, ^"position:z", drawer_open_final_pos_z, 0.25)
	open = true


func _close_drawer() -> void:

	var tween : Tween = drawer.create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(drawer, ^"position:z", drawer_closed_final_pos_z, 0.25)
	open = false
