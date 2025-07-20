class_name Door extends Interactable


@export_range(-180.0, 180.0) var target_rotation: float = 0.0


var tweening: bool = false
var opened: bool = false


func interact(event: InputEvent) -> void:

	if event.is_action_pressed(&"interact") and not tweening:

		tweening = true
		var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, ^"rotation_degrees:y", target_rotation if not opened else 0.0, 0.5)
		if tween.is_running(): await tween.finished
		tweening = false
		opened = not opened
