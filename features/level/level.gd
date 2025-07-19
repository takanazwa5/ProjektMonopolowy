class_name Level extends Node3D


@onready var counter: Counter = %Counter
@onready var fridge: Node3D = %Fridge


func _init() -> void:

	GameManager.level = self
