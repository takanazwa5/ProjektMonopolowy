class_name Game extends Node


@onready var pause_menu: PauseMenu = %PauseMenu
@onready var level: Level = %Level
@onready var player: Player = %Player


func _ready() -> void:

	player.item_rig.child_entered_tree.connect(_on_item_entered_rig)
	player.item_rig.child_exiting_tree.connect(_on_item_exited_rig)
	level.counter.interaction.connect(_on_counter_interaction)
	pause_menu.paused.connect(_on_game_paused)
	pause_menu.unpaused.connect(_on_game_unpaused)

	DebugMenu.add_button(spawn_basia)
	DebugMenu.add_button(change_window_mode)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	print("Game scene ready.")


func _process(_delta: float) -> void:

	DebugPanel.add_property(Engine.get_frames_per_second(), "FPS", 1000)


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


func _on_item_entered_rig(_node: Node) -> void:

	level.counter.can_interact = true


func _on_item_exited_rig(_node: Node) -> void:

	level.counter.can_interact = false


func _on_counter_interaction() -> void:

	level.counter.place_item_on_counter(player.item_rig.current_item)


func _on_game_paused() -> void:

	player.hud.hide()


func _on_game_unpaused() -> void:

	player.hud.show()
