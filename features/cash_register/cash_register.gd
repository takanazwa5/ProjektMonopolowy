class_name CashRegister extends Node3D


var total : float = 0.0
var paid : float = 0.0
var change : float = 0.0


@onready var total_label : Label = %TotalLabel
@onready var paid_label : Label = %PaidLabel
@onready var change_label : Label = %ChangeLabel


func _generate_random_order() -> void:

	pass
