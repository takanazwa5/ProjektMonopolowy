class_name Level extends Node3D


@onready var counter: Counter = %Counter
@onready var fridge: Node3D = %Fridge
@onready var cash_register: CashRegister = %CashRegister
@onready var main_door: Node3D = %MainDoor
@onready var mop: Item = %Mop

func _ready() -> void:
  mop.loose = true
  mop.is_disposable = false