class_name Level extends Node3D


static var instance: Level

@onready var fridge: Node3D = %Fridge
@onready var main_door: Node3D = %MainDoor
@onready var counter: Counter = %Counter
@onready var loose_items: Node = %LooseItems
@onready var player_start: Marker3D = %PlayerStart
@onready var available_items: AvailableItems = %AvailableItems

func _init() -> void:
	instance = self

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE and instance == self:
		instance = null