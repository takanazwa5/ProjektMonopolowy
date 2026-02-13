class_name AvailableItems extends Node

@export var item_name_to_instance_map: Dictionary[StringName, Item] = {}
@export var item_type_to_destination_map: Dictionary[ItemData.Type, Node3D] = {}
@export var item_name_to_destination_map: Dictionary[StringName, Node3D] = {}

func get_item(item_name: StringName) -> Item:
	if item_name in item_name_to_instance_map:
		return item_name_to_instance_map[item_name]
	else:
		push_error("No item with name %s found in AvailableItems." % item_name)
		return null

func get_all_item_names() -> Array[StringName]:
	return item_name_to_instance_map.keys()

func get_item_destination_position(item_name: StringName) -> Node3D:
	if item_name in item_name_to_destination_map:
		return item_name_to_destination_map[item_name]
	
	if item_name in item_name_to_instance_map:
		var item: Item = item_name_to_instance_map[item_name]

		if item.data.type in item_type_to_destination_map:
			return item_type_to_destination_map[item.data.type]
		else:
			push_warning("No destination defined for item type %s." % item.data.type)
			return item
	else:
		push_error("No item with name %s found in AvailableItems." % item_name)
		return null