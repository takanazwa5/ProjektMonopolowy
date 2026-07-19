extends Node

signal level_unload_started(level: Level)
signal level_unloaded
signal level_load_started
signal level_load_failed(level: PackedScene, error: int)
signal level_loaded(level: Level)

@export var initial_level_state: LevelStateData = null
@export var level_queue: Array[LevelData] = []
@export var main_menu_scene: PackedScene = null

var level_state: LevelStateData = null
var current_level_data: LevelData = null

func _ready() -> void:
	if level_queue.size() == 0:
		push_error("Level queue is empty. Please add levels to the level queue.")
		return

	DebugMenu.add_button(load_next_level)

func load_from_initial_level() -> void:
	level_state = initial_level_state.duplicate(true)
	_load_level(level_queue[level_state.current_level_idx])

func load_from_saved_state(saved_state: LevelStateData) -> void:
	level_state = saved_state
	_load_level(level_queue[level_state.current_level_idx])

func load_next_level() -> void:
	level_state.current_level_idx += 1
	if level_state.current_level_idx >= level_queue.size():
		push_warning("No more levels in the queue.")

		_unload_previous_level()
		get_tree().change_scene_to_packed(main_menu_scene)

		get_tree().paused = false
		level_state = null
		return

	_load_level(level_queue[level_state.current_level_idx])

# currently working synchronously, can be changed if needed later
func _load_level(level_data: LevelData) -> void:
	_unload_previous_level()
	level_load_started.emit()

	var level_instance: Node = level_data.level_scene.instantiate()
	var game_scene: Node = get_tree().current_scene
	if game_scene is Game:
		current_level_data = level_data
		game_scene.add_child(level_instance)
	else:
		push_error("Current scene is not a Game scene. Cannot add level instance.")
		current_level_data = null
		level_load_failed.emit(level_data.level_scene, ERR_SCRIPT_FAILED)
		return

	level_loaded.emit(level_instance)

func _unload_previous_level() -> void:
	if Level.instance == null: return
	level_unload_started.emit(Level.instance)
	
	current_level_data = null
	Level.instance.queue_free()
	level_unloaded.emit()
