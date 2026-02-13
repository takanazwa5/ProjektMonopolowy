class_name Inventory extends Node3D


func _ready() -> void:
	child_entered_tree.connect(_on_item_entered_tree)
	child_exiting_tree.connect(_on_item_exited_tree)

func add_item(item: Item) -> void:
	item.reparent(self )

func get_items() -> Array:
	return get_children()

func _on_item_entered_tree(node: Node) -> void:
	if node is Item:
		node.visible = false
		node.set_meta(&"can_interact", false)

func _on_item_exited_tree(node: Node) -> void:
	if node is Item:
		node.visible = true
		node.set_meta(&"can_interact", true)
