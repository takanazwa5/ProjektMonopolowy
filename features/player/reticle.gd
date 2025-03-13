class_name Reticle extends Control


enum Type {INACTIVE, ACTIVE}


@export var radius : float = 2.0
@export var color : Color = Color.WHITE


var type : Type:

	set(value):

		if type == value:

			return

		type = value
		queue_redraw()


func _draw() -> void:

	if type == Type.INACTIVE:

		draw_circle(size / 2, radius, color, true, -1.0, true)

	elif type == Type.ACTIVE:

		draw_circle(size / 2, radius * 2, color, false, 2.0, true)
