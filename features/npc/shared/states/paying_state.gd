class_name NPCPayingState extends NPCState


@onready var animation_tree: AnimationTree = %AnimationTree
@onready var packing_state: NPCPackingState = %PackingState


func enter() -> void:

	animation_tree.animation_finished.connect(_on_animation_finished)
	Level.cash_register.transaction_finished.connect(_on_transaction_finished)
	animation_tree.set(&"parameters/put_down/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func _on_animation_finished(anim_name: StringName) -> void:

	if anim_name == &"Rig/PutDown_Base": Level.cash_register.generate_random_order()


func _on_transaction_finished() -> void:

	transition.emit(packing_state)


func exit() -> void:

	animation_tree.animation_finished.disconnect(_on_animation_finished)
	Level.cash_register.transaction_finished.disconnect(_on_transaction_finished)
