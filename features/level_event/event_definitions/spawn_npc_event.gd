class_name SpawnNPCEvent
extends LevelEvent

enum NPCWantedProductsType {
	## The NPC will have a fixed list of products that they want.
	FIXED,
	## The NPC will have a randomized list of products that they want.
	RANDOM,
	## The NPC will not want any products.
	NONE,
}

enum NPCWantedProductsCountType {
	## The NPC will have a fixed number of products that they want.
	FIXED,
	## The NPC will have a random number of products that they want.
	RANDOM,
	## The NPC will not want any products.
	NONE,
}

## The resource ID of the NPC to spawn. This should be a path to a .tscn file that defines the NPC.
@export_file("*.tscn") var npc_resource_id: String
## The ids of NPCs to choose from randomly when spawning. This should be a list of paths to .tscn files that define the NPCs. Ignored if single npc_resource_id is set.
@export_file("*.tscn") var random_npc_resource_ids: Array[String]
@export_group("NPC Products")
@export_subgroup("Products Count")
## The type of product count for the NPC. This determines how the number of products the NPC wants is calculated.
@export var npc_wanted_products_count_type: NPCWantedProductsCountType = NPCWantedProductsCountType.NONE
## The number of products the NPC wants if the count type is FIXED. If the count type is RANDOM, this value is the upper limit.
@export var npc_number_of_products: int = 0
## The minimum number of products the NPC wants if the count type is RANDOM. This value is ignored if the count type is FIXED or NONE.
@export var npc_min_number_of_products: int = 0
@export_subgroup("Product Types")
## The type of products the NPC wants. This determines how the products are selected.
@export var npc_wanted_products_type: NPCWantedProductsType = NPCWantedProductsType.NONE
## The list of specific products that the NPC can want if the products type is FIXED. This is ignored if the product type is RANDOM or NONE.
@export var npc_wanted_products: Array[StringName] = []
## The list of product categories that the NPC can want if the products type is RANDOM. This is ignored if the product type is FIXED or NONE.
@export var npc_random_products_categories: Array[ItemData.Type] = []

func execute_event() -> void:
	var npc_spawner: NPCSpawner = Level.instance.npc_spawner
	if npc_spawner == null:
		push_error("NPCSpawner not found in the current level.")
		return
	
	var npc_to_spawn: String = npc_resource_id
	if (npc_to_spawn == "" or npc_to_spawn == null) and random_npc_resource_ids.size() > 0:
		npc_to_spawn = random_npc_resource_ids.pick_random()
	
	if npc_to_spawn == "" or npc_to_spawn == null:
		push_error("No NPC resource ID provided and no random NPC resource IDs available.")
		return

	var number_of_products: int = 0
	if npc_wanted_products_count_type == NPCWantedProductsCountType.FIXED:
		number_of_products = npc_number_of_products
	elif npc_wanted_products_count_type == NPCWantedProductsCountType.RANDOM:
		var lower_limit: int = max(npc_min_number_of_products, 0)
		if lower_limit > npc_number_of_products:
			push_warning("Minimum number of products is greater than the maximum. NPC will be spawned without any wanted products.")
			lower_limit = 0

		number_of_products = randi_range(lower_limit, npc_number_of_products)
	else:
		push_warning("NPC will be spawned without any wanted products.")

	if npc_wanted_products_type == NPCWantedProductsType.RANDOM:
		npc_spawner.spawn_npc_random_order(npc_to_spawn, number_of_products, npc_random_products_categories)
		return
	elif npc_wanted_products_type == NPCWantedProductsType.FIXED:
		npc_spawner.spawn_npc_fixed_order(npc_to_spawn, npc_wanted_products)
		return
	
	push_warning("NPC will be spawned without any wanted products.")
	npc_spawner.spawn_npc(npc_to_spawn)
