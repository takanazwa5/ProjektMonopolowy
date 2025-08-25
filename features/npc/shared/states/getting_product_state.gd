class_name NPCGettingProductState extends NPCState


@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var paying_state: NPCPayingState = %PayingState


func _ready() -> void:

	animation_tree.animation_finished.connect(_on_animation_finished)


func enter() -> void:

	npc.navigate_to_node(Level.fridge)
	await npc.navigation_agent_3d.navigation_finished
	animation_tree.set(&"parameters/pick_up/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func _on_animation_finished(anim_name: StringName) -> void:

	if anim_name == &"Rig/PickUp_Base": npc.navigate_to_node(Level.counter)
	await npc.navigation_agent_3d.navigation_finished
	transition.emit(paying_state)
