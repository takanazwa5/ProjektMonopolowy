class_name Level extends Node3D


@onready var fridge: Node3D = %Fridge
@onready var main_door: Node3D = %MainDoor
@onready var counter: Counter = %Counter


func _enter_tree() -> void:

	Global.level = self
