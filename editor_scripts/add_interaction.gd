@tool
class_name AddInteraction extends EditorScript


func _run() -> void:

	var selection: EditorSelection = EditorInterface.get_selection()
	var selected_nodes: Array[Node] = selection.get_selected_nodes()

	if selected_nodes.is_empty():

		print("No nodes selected.")
		return

	for node: Node in selected_nodes:

		node.set_meta(&"can_interact", true)
		node.set_meta(&"reticle_tooltip", "")
		print("Added interaction meta to %s" % node.name)
