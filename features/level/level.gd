class_name Level extends Node3D


static var counter: Counter
static var fridge: Node3D
static var cash_register: CashRegister


func _ready() -> void:

	counter = %Counter
	fridge = %Fridge
	cash_register = %CashRegister
