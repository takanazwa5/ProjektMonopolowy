class_name NPCPackingState extends NPCState


@onready var animation_tree: AnimationTree = %AnimationTree
@onready var exiting_store_state: NPCExitingStoreState = %ExitingStoreState


func enter() -> void:

	animation_tree.animation_finished.connect(_on_animation_finished)
	animation_tree.set(&"parameters/pick_up/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func _on_animation_finished(anim_name: StringName) -> void:

	if anim_name == &"Rig/PickUp_Base":

		Level.counter.clear()
		transition.emit(exiting_store_state)


func exit() -> void:

	animation_tree.animation_finished.disconnect(_on_animation_finished)
