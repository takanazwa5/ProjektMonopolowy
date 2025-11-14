class_name HUD extends CanvasLayer


@export var _item_preview: ItemPreview


@onready var reticle: Reticle = %Reticle
@onready var item_preview_prompt: Control = %ItemPreviewPrompt
@onready var dialog: Dialog = %Dialog


func _ready() -> void:

	_item_preview.item_entered.connect(_on_item_entered_preview)
	_item_preview.item_exited.connect(_on_item_exited_preview)
	dialog.opened.connect(reticle.hide)
	dialog.closed.connect(reticle.show)


func on_game_paused() -> void:

	hide()


func on_game_unpaused() -> void:

	show()


func _on_item_entered_preview(_item: Item) -> void:

	item_preview_prompt.show()


func _on_item_exited_preview() -> void:

	item_preview_prompt.hide()
