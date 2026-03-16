class_name NPCPackingState extends NPCState


@onready var animation_tree: AnimationTree = %AnimationTree


func enter() -> void:
	animation_tree.animation_finished.connect(_on_animation_finished)
	animation_tree.set(&"parameters/pick_up/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func input_event(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"Rig/PickUp_Base":
		Counter.instance.clear()
		transition.emit(npc.brain.get_next_state(self))


func exit() -> void:
	animation_tree.animation_finished.disconnect(_on_animation_finished)
	if Game.instance.npc_queue.peek() == npc:
		Game.instance.npc_queue.dequeue()
		Game.instance.move_npc_queue()
	else:
		push_error("NPC %s opuszczający kolejkę nie jest na jej początku!" % npc.name)
