class_name NPCStandingInQueueState
extends NPCState

const QUEUE_SPACING: float = 1.0

func enter() -> void:
	if Game.instance.npc_queue.is_empty():
		print("Kolejka jest pusta.")
		_move_to_counter()
	else:
		print("%s staje w kolejce." % npc.name)
		_move_to_queue_end()
		
	Game.instance.npc_queue.enqueue(npc)
	Game.instance.npc_in_queue_moved.connect(_move_in_queue)

func input_event(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func _move_to_counter() -> void:
	print("%s podchodzi do lady." % npc.name)
	npc.navigate_to_node(Counter.instance)
	await npc.nav_agent.navigation_finished
	transition.emit(npc.brain.get_next_state(self))

func _move_to_queue_end() -> void:
	print("%s przesuwa się na koniec kolejki." % npc.name)
	_move_behind_npc(Game.instance.npc_queue.peek_tail())

func _move_in_queue(queued_npc: Game.QueuedNPC) -> void:
	if queued_npc.npc != npc: return

	print("%s przesuwa się w kolejce." % npc.name)
	if Game.instance.npc_queue.peek() == npc:
		_move_to_counter()
	else:
		_move_behind_npc(queued_npc.previous.npc)

func _move_behind_npc(target_npc: NPC) -> void:
	var queue_position: Node3D = _create_temporary_position_node()
	queue_position.global_position = target_npc.global_position + Vector3(0, 0, QUEUE_SPACING)
	npc.navigate_to_node(queue_position)
	await npc.nav_agent.navigation_finished
	queue_position.queue_free()
	_look_at_counter()

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
