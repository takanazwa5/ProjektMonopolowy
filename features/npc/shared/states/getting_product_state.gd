class_name NPCGettingProductState extends NPCState


@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var paying_state: NPCPayingState = %PayingState


func enter() -> void:

	animation_tree.animation_finished.connect(_on_animation_finished)
	npc.navigate_to_node(Global.level.fridge)
	await npc.nav_agent.navigation_finished
	animation_tree.set(&"parameters/pick_up/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func input_event(_event: InputEvent) -> void:

	pass


func update(_delta: float) -> void:

	pass


func physics_update(_delta: float) -> void:

	pass


func _on_animation_finished(anim_name: StringName) -> void:

	if anim_name == &"Rig/PickUp_Base": npc.navigate_to_node(Global.counter)
	await npc.nav_agent.navigation_finished
	transition.emit(paying_state)


func exit() -> void:

	animation_tree.animation_finished.disconnect(_on_animation_finished)
