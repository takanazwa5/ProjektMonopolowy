extends CanvasLayer


var _label_settings : LabelSettings = LabelSettings.new()


@onready var labels_container : VBoxContainer = %LabelsContainer


func _ready() -> void:

	visible = OS.is_debug_build()

	_label_settings.outline_color = Color.BLACK
	_label_settings.outline_size = 10


func _unhandled_input(event: InputEvent) -> void:

	if not OS.is_debug_build():

		return

	if event is InputEventKey and event.pressed and not event.echo:

		if event.physical_keycode == KEY_F1:

			visible = not visible


func add_property(value: Variant, display_name: String, priority: int = 0) -> void:

	if not labels_container.get_node_or_null(display_name):

		var label : Label = Label.new()
		label.name = display_name
		label.label_settings = _label_settings
		label.set_meta(&"priority", priority)
		labels_container.add_child(label)

		if priority == 0:

			return

		for i : int in labels_container.get_child_count():

			var child : Label = labels_container.get_child(i)
			if child.get_meta(&"priority") < label.get_meta(&"priority"):

				labels_container.move_child(label, i)
				return

	elif visible:

		var label : Label = labels_container.get_node(display_name)
		label.text = "%s: %s" % [display_name, value]
