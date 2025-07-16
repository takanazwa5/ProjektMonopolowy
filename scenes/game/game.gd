class_name Game extends Node


func _ready() -> void:

	print("Game scene ready.")

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(_delta: float) -> void:

	DebugPanel.add_property(Engine.get_frames_per_second(), "FPS", 1000)
