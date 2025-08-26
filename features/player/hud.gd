class_name HUD extends CanvasLayer


@onready var reticle: Reticle = %Reticle
@onready var item_preview: ItemPreview = %ItemPreview
@onready var item_preview_prompt: Control = %ItemPreviewPrompt


func _ready() -> void:

	item_preview.child_entered_tree.connect(_on_item_entered_preview)
	item_preview.child_exiting_tree.connect(_on_item_exited_preview)


func _on_item_entered_preview(_node: Node) -> void:

	item_preview_prompt.show()


func _on_item_exited_preview(_node: Node) -> void:

	item_preview_prompt.hide()
