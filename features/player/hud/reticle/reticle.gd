class_name Reticle extends Control


const RADIUS: float = 2.0
const COLOR: Color = Color.WHITE


var collider: Object:

	set(value):

		if collider == value: return
		collider = value
		_active = is_instance_valid(collider) and collider.get_meta(&"can_interact", false)


var _active: bool = false:

	set(value):

		_active = value
		queue_redraw()

		if _active:

			reticle_tooltip.text = collider.get_meta(&"reticle_tooltip", "")
			reticle_tooltip.show()

		else: reticle_tooltip.hide()


@onready var reticle_tooltip: Label = %ReticleTooltip


func _ready() -> void:

	var counter: Counter = get_tree().get_first_node_in_group(&"counter")
	counter.item_placed.connect(_on_counter_item_placed)
	# Don't really like this approach but have to live with it for now.


func _draw() -> void:

	if not _active:

		draw_circle(size / 2, RADIUS, COLOR, true, -1.0, true)

	else:

		draw_circle(size / 2, RADIUS * 2, COLOR, false, 2.0, true)


func _on_counter_item_placed(_item_data: ItemData) -> void:

	_active = false
