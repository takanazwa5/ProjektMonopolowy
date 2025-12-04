@tool
class_name AddItemThings extends EditorScript


func _run() -> void:

	var selection: EditorSelection = EditorInterface.get_selection()
	var selected_nodes: Array[Node] = selection.get_selected_nodes()

	if not selected_nodes.size() == 1:

		selected_nodes.append(EditorInterface.get_edited_scene_root())
		return

	if not selected_nodes[0] is Item: return

	var selected_node: Item = selected_nodes[0]
	selected_node.collision_layer = 4
	selected_node.collision_mask = 5
	selected_node.freeze = true
	selected_node.add_to_group(&"items")
	print("Added item things")
