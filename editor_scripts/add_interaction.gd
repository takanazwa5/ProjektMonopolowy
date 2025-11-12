@tool
class_name AddInteraction extends EditorScript


func _run() -> void:

	var selection: EditorSelection = EditorInterface.get_selection()
	var selected_nodes: Array[Node] = selection.get_selected_nodes()

	if selected_nodes.is_empty():

		selected_nodes.append(EditorInterface.get_edited_scene_root())

	if selected_nodes.size() == 1:

		var window: Window = Window.new()
		window.size = Vector2i(500, 30)
		window.unresizable = true
		var line_edit: LineEdit = LineEdit.new()
		line_edit.size = Vector2i(500, 20)
		line_edit.text_submitted.connect(func(_text: String) -> void:
			_add_interaction(selected_nodes[0], line_edit.text)
			window.queue_free()
		)
		window.add_child(line_edit)

		window.close_requested.connect(window.queue_free)
		EditorInterface.popup_dialog_centered(window)
		line_edit.grab_focus()

	else:

		for node: Node in selected_nodes:

			_add_interaction(node)


func _add_interaction(node: Node, reticle_tooltip: String = "") -> void:

	node.set_meta(&"can_interact", true)
	node.set_meta(&"reticle_tooltip", reticle_tooltip)
	print("Added interaction meta to %s" % node.name)
