class_name EventEntry
extends Resource

@export var event: LevelEvent
@export var delay: float = 0.0
@export var repeatable: bool = false
@export_group("Repeatable Properties")
@export var cooldown: float = 0.0
@export var number_of_repeats: int = 0