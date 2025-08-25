class_name NPCPayingState extends NPCState


@onready var animation_tree: AnimationTree = %AnimationTree


func _ready() -> void:

	animation_tree.animation_finished.connect(_on_animation_finished)


func enter() -> void:

	animation_tree.set(&"parameters/put_down/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func _on_animation_finished(anim_name: StringName) -> void:

	if anim_name == &"Rig/PutDown_Base": Level.cash_register.generate_random_order()
