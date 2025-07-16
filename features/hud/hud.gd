class_name HUD extends CanvasLayer


@onready var reticle: Reticle = %Reticle
@onready var item_preview_prompt: Control = %ItemPreviewPrompt


func _ready() -> void:

	GameManager.pause_menu.paused.connect(hide)
	GameManager.pause_menu.unpaused.connect(show)
	SignalBus.item_entered_preview.connect(_on_item_entered_preview)
	SignalBus.item_exited_preview.connect(_on_item_exited_preview)


func _on_item_entered_preview() -> void:

	item_preview_prompt.show()


func _on_item_exited_preview() -> void:

	item_preview_prompt.hide()
