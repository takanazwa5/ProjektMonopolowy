class_name Reticle extends Control


@export var radius : float = 2.0
@export var color : Color = Color.WHITE


var active : bool = false:

	set(value):

		if active == value:

			return

		active = value
		queue_redraw()


func _draw() -> void:

	if not active:

		draw_circle(size / 2, radius, color, true, -1.0, true)

	else:

		draw_circle(size / 2, radius * 2, color, false, 2.0, true)
