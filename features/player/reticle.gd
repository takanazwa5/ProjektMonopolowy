class_name Reticle extends Control


@export var radius : float = 2.0
@export var color : Color = Color.WHITE


func _draw() -> void:

	draw_circle(size / 2, radius, color)
