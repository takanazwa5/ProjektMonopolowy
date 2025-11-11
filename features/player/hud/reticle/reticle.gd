class_name Reticle extends Control


const RADIUS: float = 2.0
const COLOR: Color = Color.WHITE


var collider: Object:

	set(value):

		if collider == value: return
		collider = value
		_active = collider is Interactable and collider.can_interact


var _active: bool = false:

	set(value):

		if _active == value: return
		_active = value
		queue_redraw()

		if _active:

			reticle_tooltip.text = collider.reticle_tooltip_text
			reticle_tooltip.show()

		else: reticle_tooltip.hide()


@onready var reticle_tooltip: Label = %ReticleTooltip


func _draw() -> void:

	if not _active:

		draw_circle(size / 2, RADIUS, COLOR, true, -1.0, true)

	else:

		draw_circle(size / 2, RADIUS * 2, COLOR, false, 2.0, true)


func set_active(active: bool) -> void:

	_active = active
