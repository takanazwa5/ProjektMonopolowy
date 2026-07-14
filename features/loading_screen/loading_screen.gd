class_name LoadingScreen
extends CanvasLayer

@onready var loading_indicator: TextureProgressBar = %LoadingIndicator

func _ready() -> void:
	LevelManager.level_unload_started.connect(_on_level_unload)
	LevelManager.level_loaded.connect(_on_level_loaded)

func _process(delta: float) -> void:
	if loading_indicator.visible:
		if loading_indicator.fill_mode == TextureProgressBar.FILL_CLOCKWISE:
			loading_indicator.value += 100.0 * delta
		elif loading_indicator.fill_mode == TextureProgressBar.FILL_COUNTER_CLOCKWISE:
			loading_indicator.value -= 100.0 * delta

		if loading_indicator.value >= loading_indicator.max_value:
			loading_indicator.fill_mode = TextureProgressBar.FILL_COUNTER_CLOCKWISE
		elif loading_indicator.value <= loading_indicator.min_value:
			loading_indicator.fill_mode = TextureProgressBar.FILL_CLOCKWISE

func _on_level_unload(_level: Level) -> void:
	loading_indicator.value = 0.0
	show()

func _on_level_loaded(_level: Level) -> void:
	hide()