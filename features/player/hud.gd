class_name HUD extends CanvasLayer


func _ready() -> void:

	GameManager.pause_menu.paused.connect(hide)
	GameManager.pause_menu.unpaused.connect(show)
