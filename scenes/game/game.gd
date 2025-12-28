class_name Game extends Node


@onready var pause_menu: PauseMenu = %PauseMenu
@onready var level: Level = %Level
@onready var player: Player = %Player
@onready var loose_items: Node = %LooseItems


func _ready() -> void:
	player.item_rig.item_entered.connect(level.counter.on_item_entered_rig)
	player.item_rig.item_exited.connect(level.counter.on_item_exited_rig)
	pause_menu.paused.connect(player.hud.on_game_paused)
	pause_menu.unpaused.connect(player.hud.on_game_unpaused)

	DebugMenu.add_button(spawn_basia)
	DebugMenu.add_button(change_window_mode)
	DebugMenu.add_button(spawn_trash)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	print("Game scene ready.")


func _process(_delta: float) -> void:
	DebugPanel.add_property(Engine.get_frames_per_second(), "FPS", 1000)
	DebugPanel.add_property(loose_items.get_child_count(), "Loose Items Count", 100)

func spawn_basia() -> void:
	var basia_scene: PackedScene = load("uid://civlo6dh6d0kf")
	var basia: NPC = basia_scene.instantiate()
	add_child(basia)
	basia.position = Vector3(-1.48, 0.125, 3.42)
	basia.rotation_degrees = Vector3(0.0, -180.0, 0.0)

func change_window_mode() -> void:
	var window: Window = get_window()
	if window.mode == Window.MODE_WINDOWED: window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else: window.mode = Window.MODE_WINDOWED

func spawn_trash() -> void:
	var trash_container: Node3D = level.get_node("TrashContainer")
	trash_container.spawn_trash(1)