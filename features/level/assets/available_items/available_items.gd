class_name AvailableItems extends Node

var item_name_to_instance_map: Dictionary[StringName, Item] = {}
@export var item_type_to_destination_map: Dictionary[ItemData.Type, Node3D] = {}
@export var item_name_to_destination_map: Dictionary[StringName, Node3D] = {}
@export var pickup_at_counter_required: Dictionary[StringName, bool] = {}
@export var pickup_at_counter_type_required: Dictionary[ItemData.Type, bool] = {}

var item_names: Array[StringName] = []
var item_names_by_type: Dictionary[ItemData.Type, Array] = {
	ItemData.Type.SZLUGI: [],
	ItemData.Type.PIWO: [],
	ItemData.Type.WINO: [],
	ItemData.Type.MISC: []
}

func _ready() -> void:
	for item: Item in get_tree().get_nodes_in_group(&"items"):
		if item.data.name not in item_names and item.data is ProductData:
			item_names.append(item.data.name)
			item_name_to_instance_map[item.data.name] = item

			if item.data.type == ItemData.Type.APPLIANCE:
				continue
			item_names_by_type[item.data.type].append(item.data.name)

func get_item(item_name: StringName) -> Item:
	if item_name in item_name_to_instance_map:
		return item_name_to_instance_map[item_name]
	else:
		push_error("No item with name %s found in AvailableItems." % item_name)
		return null

func get_all_item_names() -> Array[StringName]:
	return item_names

# Checks in order: 
# 1. If product, by name, needs to be picked up at counter 
# 2. Destination of pickup by product name
# 3. If product type needs to be picked up at counter
# 4. Destination of pickup by product type
# 5. Returns the ite itself as a fallback destination
func get_item_destination_position(item_name: StringName) -> Node3D:
	# if product is not available, return error
	if not item_name in item_name_to_instance_map:
		push_error("No item with name %s found in AvailableItems." % item_name)
		return null

	# If pickup of item, by product name, at counter is required, return counter as destination
	if pickup_at_counter_required.get(item_name, false):
		return Counter.instance

	# If product, by name, has defined pickup destination, return it
	if item_name in item_name_to_destination_map:
		return item_name_to_destination_map[item_name]
	
	var item: Item = item_name_to_instance_map[item_name]
	# If product type needs to be picked up at counter, return counter as destination
	if pickup_at_counter_type_required.get(item.data.type, false):
		return Counter.instance

	# If product type has defined pickup destination, return it
	if item.data.type in item_type_to_destination_map:
		return item_type_to_destination_map[item.data.type]
	
	push_warning("No destination defined for item type %s." % item.data.type)
	return item
