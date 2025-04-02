class_name CashRegister extends StaticBody3D


var total : float = 0.0
var paid : float = 0.0
var change : float = 0.0


@onready var total_label : Label = %TotalLabel
@onready var paid_label : Label = %PaidLabel
@onready var change_label : Label = %ChangeLabel
@onready var drawer : CashRegisterDrawer = %Drawer
@onready var labels_container : VBoxContainer = %LabelsContainer


func _ready() -> void:

	for node : Money in get_tree().get_nodes_in_group(&"Cash"):

		node.interaction.connect(_on_cash_interaction)


func _unhandled_key_input(_event: InputEvent) -> void:

	if Input.is_physical_key_pressed(KEY_BRACKETRIGHT):

		_generate_random_order()


func _generate_random_order() -> void:

	total = randf_range(50.0, 200.0)
	total = snappedf(total, 0.05)

	var paid_rounding : float = [10.0, 20.0, 50.0].pick_random()
	paid = snappedf(total, paid_rounding)
	paid += paid_rounding if paid <= total else 0.0

	total_label.text = str(total)
	paid_label.text = str(paid)

	labels_container.show()

	if not drawer.open:

		drawer.open_drawer()


func _change_value_changed(value: float) -> void:

	change = clampf(change + value, 0.0, 1000.0)
	change_label.text = str(change)
	if is_equal_approx(paid, total + change):

		drawer.close_drawer()
		labels_container.hide()
		total = 0.0
		paid = 0.0
		change = 0.0


func _on_cash_interaction(value: float) -> void:

	_change_value_changed(value)
