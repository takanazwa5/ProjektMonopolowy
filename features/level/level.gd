class_name Level extends Node3D


static var instance: Level


@onready var fridge: Node3D = %Fridge
@onready var main_door: Node3D = %MainDoor
@onready var counter: Counter = %Counter
@onready var available_items: AvailableItems = %AvailableItems

func _init() -> void:
  instance = self