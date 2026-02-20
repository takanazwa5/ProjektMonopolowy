class_name Game extends Node

signal npc_in_queue_moved(queued_npc: QueuedNPC)

static var instance: Game

@onready var pause_menu: PauseMenu = %PauseMenu
@onready var level: Level = %Level
@onready var player: Player = %Player
@onready var loose_items: Node = %LooseItems
@onready var npcs: Node = %NPCs

var npc_queue: NPCQueue

func _init() -> void:
	instance = self

func _ready() -> void:
	player.item_rig.item_entered.connect(level.counter.on_item_entered_rig)
	player.item_rig.item_exited.connect(level.counter.on_item_exited_rig)
	pause_menu.paused.connect(player.hud.on_game_paused)
	pause_menu.unpaused.connect(player.hud.on_game_unpaused)

	DebugMenu.add_button(spawn_basia)
	DebugMenu.add_button(change_window_mode)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	npc_queue = NPCQueue.new()
	
	print("Game scene ready.")


func _process(_delta: float) -> void:
	DebugPanel.add_property(Engine.get_frames_per_second(), "FPS", 1000)


func spawn_basia() -> void:
	var basia_scene: PackedScene = load("uid://civlo6dh6d0kf")
	var basia: NPC = basia_scene.instantiate()
	npcs.add_child(basia)
	basia.position = Vector3(-1.48, 0.125, 3.42)
	basia.rotation_degrees = Vector3(0.0, -180.0, 0.0)


func change_window_mode() -> void:
	var window: Window = get_window()
	if window.mode == Window.MODE_WINDOWED: window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else: window.mode = Window.MODE_WINDOWED

func move_npc_queue() -> void:
	for queued_npc in npc_queue.list():
		npc_in_queue_moved.emit(queued_npc)
		await queued_npc.npc.nav_agent.navigation_finished

class NPCQueue:
	var head: QueuedNPC
	var tail: QueuedNPC

	func enqueue(npc: NPC) -> void:
		var new_queued_npc: QueuedNPC = QueuedNPC.new()
		new_queued_npc.npc = npc
		new_queued_npc.next = null
		new_queued_npc.previous = tail

		if self.is_empty():
			head = new_queued_npc
			tail = new_queued_npc
		else:
			tail.next = new_queued_npc
			tail = new_queued_npc

	func dequeue() -> NPC:
		if not self.is_empty():
			var npc: NPC = head.npc
			head = head.next
			if self.is_empty():
				tail = null
			else:
				head.previous = null
			return npc
		return null

	func peek() -> NPC:
		if not self.is_empty():
			return head.npc
		return null

	func peek_tail() -> NPC:
		if not self.is_empty():
			return tail.npc
		return null

	func is_empty() -> bool:
		return head == null

	func list() -> Array[QueuedNPC]:
		var npcs: Array[QueuedNPC] = []
		var current: QueuedNPC = head
		while current != null:
			npcs.append(current)
			current = current.next
		return npcs

class QueuedNPC:
	var npc: NPC
	var next: QueuedNPC
	var previous: QueuedNPC
