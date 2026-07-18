class_name NPCSpawner
extends Node

@export var spawn_point: Node3D
@export var spawn_rotation_offset: Vector3 = Vector3.ZERO
@export var spawn_offset: Vector3 = Vector3.ZERO

func spawn_npc(resource_id: String) -> void:
	if Game.instance == null:
		push_error("Game instance is null. Cannot spawn NPC.")
		return

	var npc: NPC = _instantiate_npc(resource_id)

	_add_npc_to_scene(npc)

func spawn_npc_random_order(resource_id: String, number_of_items: int, item_categories_wanted: Array[ItemData.Type]) -> void:
	if Game.instance == null:
		push_error("Game instance is null. Cannot spawn NPC.")
		return

	var npc: NPC = _instantiate_npc(resource_id)
	npc.number_of_products_wanted = number_of_items
	npc.wanted_product_categories = item_categories_wanted.duplicate()

	_add_npc_to_scene(npc)

func spawn_npc_fixed_order(resource_id: String, wanted_products: Array[StringName]) -> void:
	if Game.instance == null:
		push_error("Game instance is null. Cannot spawn NPC.")
		return

	var npc: NPC = _instantiate_npc(resource_id)
	npc.wanted_products = wanted_products.duplicate(true)

	_add_npc_to_scene(npc)

func _instantiate_npc(resource_id: String) -> NPC:
	var npc_scene: PackedScene = load(resource_id)
	var npc: NPC = npc_scene.instantiate()
	return npc

func _add_npc_to_scene(npc: NPC) -> void:
	if Game.instance == null:
		push_error("Game instance is null. Cannot add NPC to scene.")
		return

	Game.instance.npcs.add_child(npc)
	npc.global_position = spawn_point.global_position + spawn_offset
	npc.global_rotation_degrees = spawn_point.global_rotation_degrees + spawn_rotation_offset