class_name NPCStandingInQueueState
extends NPCState

const QUEUE_SPACING: float = 0.75
const FIRST_IN_QUEUE_OFFSET: Vector3 = Vector3(0, 0, 0.75)

func enter() -> void:
	Game.instance.npc_queue.enqueue(npc)
	_move_to_queue_position(Game.instance.npc_queue.list().size() - 1)
	Game.instance.npc_in_queue_moved.connect(_move_in_queue)

func input_event(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func _move_in_queue(queued_npc: Game.QueuedNPC, position_in_queue: int) -> void:
	if queued_npc.npc != npc: return

	_move_to_queue_position(position_in_queue)

func _move_to_queue_position(index: int) -> void:
	var queue_position: Node3D
	if index == 0:
		npc.navigate_to_node(Counter.instance)
		await npc.nav_agent.navigation_finished
	else:
		var base_position: Vector3 = Counter.instance.global_position

		queue_position = _create_temporary_position_node()
		queue_position.global_position = base_position + Vector3(0, 0, QUEUE_SPACING * index) + FIRST_IN_QUEUE_OFFSET
		npc.navigate_to_node(queue_position)

	await npc.nav_agent.navigation_finished
	_look_at_counter()
	queue_position.queue_free()

	if index == 0:
		transition.emit(npc.brain.get_next_state(self))

func _create_temporary_position_node() -> Node3D:
	var temp_node: Node3D = Node3D.new()
	get_tree().current_scene.add_child(temp_node)
	return temp_node

func _look_at_counter() -> void:
	var target_pos: Vector3 = Counter.instance.global_position
	target_pos.y = npc.global_position.y
	var target_transform: Transform3D = npc.transform.looking_at(target_pos, Vector3.UP, true)
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(npc, ^"transform", target_transform, 0.25)

func exit() -> void:
	Game.instance.npc_in_queue_moved.disconnect(_move_in_queue)
