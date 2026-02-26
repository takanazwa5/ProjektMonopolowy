class_name NPCGettingProductState extends NPCState

var wanted_products: Array[StringName]
var counter_pickup_required_products: Array[StringName]
var current_product: StringName

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var standing_in_queue_state: NPCStandingInQueueState = %StandingInQueueState


func enter() -> void:
	animation_tree.animation_finished.connect(_on_animation_finished)
	counter_pickup_required_products = []
	wanted_products = []
	for product_name in npc.wanted_products:
		if Level.instance.available_items.pickup_at_counter_required.get(product_name, false):
			counter_pickup_required_products.append(product_name)
		else:
			wanted_products.append(product_name)

	_go_to_next_product()


func input_event(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass

func _go_to_next_product() -> void:
	if wanted_products.size() > 0:
		current_product = wanted_products.pop_front()
		_get_product(current_product)
	else:
		transition.emit(standing_in_queue_state)

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

	_go_to_next_product()


func exit() -> void:
	animation_tree.animation_finished.disconnect(_on_animation_finished)
