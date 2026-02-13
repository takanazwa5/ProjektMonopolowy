class_name NPCGettingProductState extends NPCState

var wanted_products: Array[StringName]
var current_product: StringName

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var paying_state: NPCPayingState = %PayingState


func enter() -> void:

	animation_tree.animation_finished.connect(_on_animation_finished)
	wanted_products = npc.wanted_products.duplicate()
	current_product = wanted_products.pop_front()
	_get_product(current_product)


func input_event(_event: InputEvent) -> void:

	pass


func update(_delta: float) -> void:

	pass


func physics_update(_delta: float) -> void:
	pass

func _get_product(product_name: StringName) -> void:
	var item: Item = Level.instance.available_items.get_item(product_name)
	var destination: Node3D = Level.instance.available_items.get_item_destination_position(product_name)

	if is_instance_valid(item):
		npc.navigate_to_node(destination)
		await npc.nav_agent.navigation_finished
		animation_tree.set(&"parameters/pick_up/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
		if item.loose:
			npc.inventory.add_item(item)
		else:
			var item_copy: Item = item.duplicate()
			get_tree().current_scene.add_child(item_copy)
			npc.inventory.add_item(item_copy)

func _on_animation_finished(anim_name: StringName) -> void:
	if not anim_name == &"Rig/PickUp_Base": return

	if wanted_products.size() > 0:
		current_product = wanted_products.pop_front()
		_get_product(current_product)
	else:
		npc.navigate_to_node(Counter.instance)
		await npc.nav_agent.navigation_finished
		transition.emit(paying_state)


func exit() -> void:

	animation_tree.animation_finished.disconnect(_on_animation_finished)
