class_name CashRegister extends StaticBody3D

signal transaction_finished

static var instance: CashRegister

const PAYMENT_ROUNDING_OPTIONS: Array[float] = [10.0, 20.0, 50.0]
const TOTAL_ROUNDING_OPTIONS: Array[float] = [1.0, 0.5]
const RANDOM_TOTAL_MIN: float = 50.0
const RANDOM_TOTAL_MAX: float = 200.0
const MAX_CHANGE: float = 1000.0

var is_order_in_progress: bool = false
var total: float = 0.0
var paid: float = 0.0
var change: float = 0.0

@onready var total_label: Label = %TotalLabel
@onready var paid_label: Label = %PaidLabel
@onready var change_label: Label = %ChangeLabel
@onready var drawer: CashRegisterDrawer = %Drawer
@onready var labels_container: VBoxContainer = %LabelsContainer

func _init() -> void:
	instance = self

func _ready() -> void:
	Counter.instance.product_placed.connect(_on_item_add_to_order)
	
	for node: Money in get_tree().get_nodes_in_group(&"Cash"):
		node.interaction.connect(_on_cash_interaction)

func start_new_order() -> void:
	if not _can_start_new_order():
		return

	_begin_order()

func generate_order_and_payment() -> void:
	paid = _calculate_payment_for_total(total)
	_show_order()

func generate_random_order() -> void:
	total = _generate_random_total()
	paid = _calculate_payment_for_total(total)
	_show_order()

func _can_start_new_order() -> bool:
	if is_order_in_progress:
		push_error("Cannot start a new order while another order is in progress.")
		return false

	return true

func _begin_order() -> void:
	is_order_in_progress = true
	reset_order()
	labels_container.hide()

func reset_order() -> void:
	total = 0.0
	paid = 0.0
	change = 0.0

func _display_current_order() -> void:
	_update_order_display()
	labels_container.show()

func _generate_random_total() -> float:
	var total_rounding: float = TOTAL_ROUNDING_OPTIONS.pick_random()
	var random_total: float = randf_range(RANDOM_TOTAL_MIN, RANDOM_TOTAL_MAX)
	return snappedf(random_total, total_rounding)

func _calculate_payment_for_total(order_total: float) -> float:
	var paid_rounding: float = PAYMENT_ROUNDING_OPTIONS.pick_random()
	var rounded_payment: float = snappedf(order_total, paid_rounding)
	if rounded_payment <= order_total:
		rounded_payment += paid_rounding

	return rounded_payment

func _show_order() -> void:
	_display_current_order()
	if not drawer.open:
		drawer.open_drawer()

func _update_order_display() -> void:
	total_label.text = str(total)
	paid_label.text = str(paid)
	change_label.text = str(change)

func _change_value_changed(value: float) -> void:
	change = clampf(change + value, 0.0, MAX_CHANGE)
	change_label.text = str(change)

	if _is_transaction_complete():
		_finish_transaction()

func _is_transaction_complete() -> bool:
	return is_equal_approx(paid, total + change)

func _finish_transaction() -> void:
	drawer.close_drawer()
	labels_container.hide()
	reset_order()
	is_order_in_progress = false
	transaction_finished.emit()

func _on_cash_interaction(value: float) -> void:
	_change_value_changed(value)

func _on_item_add_to_order(item_data: ProductData) -> void:
	if not is_order_in_progress:
		return

	total += item_data.price
	_update_order_display()