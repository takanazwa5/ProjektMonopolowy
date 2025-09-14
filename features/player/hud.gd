class_name HUD extends CanvasLayer


@onready var reticle: Reticle = %Reticle
@onready var item_preview: ItemPreview = %ItemPreview
@onready var item_preview_prompt: Control = %ItemPreviewPrompt


func _ready() -> void:

	item_preview.item_entered.connect(_on_item_entered_preview)
	item_preview.item_exited.connect(_on_item_exited_preview)


func on_game_paused() -> void:

	hide()


func on_game_unpaused() -> void:

	show()


func _on_item_entered_preview(_item: Item) -> void:

	item_preview_prompt.show()


func _on_item_exited_preview() -> void:

	item_preview_prompt.hide()
