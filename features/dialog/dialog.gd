class_name Dialog extends Control


signal opened
signal closed


const ANIMATION_SPEED: float = 1.0


var tween: Tween


@onready var dialog_label: Label = %DialogLabel


func open(who: String, what: String) -> void:

	opened.emit()
	dialog_label.text = "%s: %s" % [who, what]
	dialog_label.visible_characters = who.length()
	show()
	tween = create_tween()
	tween.tween_property(dialog_label, ^"visible_ratio", 1.0, ANIMATION_SPEED)


func _input(event: InputEvent) -> void:

	if not visible: return

	if event.is_action_pressed(&"LMB"):

		if dialog_label.visible_ratio < 1.0:

			tween.kill()
			dialog_label.visible_ratio = 1.0

		else:

			closed.emit()
			hide()
