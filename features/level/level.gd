class_name Level extends Node3D


static var fridge: Node3D
static var cash_register: CashRegister
static var main_door: Marker3D


@onready var counter: Counter = %Counter


func _ready() -> void:

	fridge = %Fridge
	cash_register = %CashRegister
	main_door = %MainDoor
