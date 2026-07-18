class_name Game extends Node

signal npc_in_queue_moved(queued_npc: QueuedNPC, position_in_queue: int)

static var instance: Game = null

@onready var pause_menu: PauseMenu = %PauseMenu
@onready var player: Player = %Player
@onready var npcs: Node = %NPCs

var npc_queue: NPCQueue
var debug_buttons: Array[Node] = []

func _init() -> void:
	instance = self

func _ready() -> void:
	LevelManager.level_unload_started.connect(_on_level_unload_started)
	LevelManager.level_loaded.connect(_on_level_loaded)

	if Level.instance == null:
		LevelManager.load_from_initial_level()

	pause_menu.paused.connect(player.hud.on_game_paused)
	pause_menu.unpaused.connect(player.hud.on_game_unpaused)

	debug_buttons.append(DebugMenu.add_button(spawn_basia))
	debug_buttons.append(DebugMenu.add_button(spawn_babcia))
	debug_buttons.append(DebugMenu.add_button(change_window_mode))

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	npc_queue = NPCQueue.new()

	print("Game scene ready.")

func _process(_delta: float) -> void:
	DebugPanel.add_property(Engine.get_frames_per_second(), "FPS", 1000)

func _notification(what: int) -> void:
	if what != NOTIFICATION_PREDELETE: return

	for button in debug_buttons:
		button.queue_free()

func connect_level_signals() -> void:
	player.item_rig.item_entered.connect(Level.instance.counter.on_item_entered_rig)
	player.item_rig.item_exited.connect(Level.instance.counter.on_item_exited_rig)

func disconnect_level_signals() -> void:
	player.item_rig.item_entered.disconnect(Level.instance.counter.on_item_entered_rig)
	player.item_rig.item_exited.disconnect(Level.instance.counter.on_item_exited_rig)

func spawn_basia() -> void:
	Level.instance.npc_spawner.spawn_npc("uid://civlo6dh6d0kf")

func spawn_babcia() -> void:
	Level.instance.npc_spawner.spawn_npc("uid://cnriyx451qbnt")

func change_window_mode() -> void:
	var window: Window = get_window()
	if window.mode == Window.MODE_WINDOWED: window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else: window.mode = Window.MODE_WINDOWED

func move_npc_queue() -> void:
	var index: int = 0
	for queued_npc in npc_queue.list():
		npc_in_queue_moved.emit(queued_npc, index)
		await queued_npc.npc.nav_agent.navigation_finished
		index += 1

func _on_level_unload_started(_level: Level) -> void:
	disconnect_level_signals()
	for npc in npcs.get_children():
		npc.queue_free()

	npc_queue.clear()

func _on_level_loaded(_level: Level) -> void:
	connect_level_signals()

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

	func clear() -> void:
		head = null
		tail = null

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
