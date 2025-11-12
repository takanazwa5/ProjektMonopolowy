class_name Dialog extends Control


signal opened
signal closed


const ANIMATION_SPEED: float = 1.0


@onready var dialog_label: Label = %DialogLabel


func open(who: String, what: String) -> void:

	opened.emit()
	dialog_label.text = "%s: %s" % [who, what]
	dialog_label.visible_characters = who.length()
	show()
	var tween: Tween = create_tween()
	tween.tween_property(dialog_label, ^"visible_ratio", 1.0, ANIMATION_SPEED)


func _input(_event: InputEvent) -> void:

	if not visible: return
	print("XD")
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):

		if dialog_label.visible_ratio < 1.0: dialog_label.visible_ratio = 1.0
		else:

			closed.emit()
			hide()
