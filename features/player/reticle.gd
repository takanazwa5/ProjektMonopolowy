class_name Reticle extends Control


enum Type {INACTIVE, ACTIVE}


@export var radius : float = 2.0
@export var color : Color = Color.WHITE


@onready var item_preview: ItemPreview = %ItemPreview
@onready var reticle_tooltip : Label = %ReticleTooltip


var type : Type:

	set(value):

		if type == value:

			return

		type = value
		queue_redraw()


func _ready() -> void:

	item_preview.child_entered_tree.connect(_on_item_entered_preview)
	item_preview.child_exiting_tree.connect(_on_item_exited_preview)


func _draw() -> void:

	if type == Type.INACTIVE:

		draw_circle(size / 2, radius, color, true, -1.0, true)

	elif type == Type.ACTIVE:

		draw_circle(size / 2, radius * 2, color, false, 2.0, true)


func _process(_delta: float) -> void:

	var collider : Object = GameManager.player.interaction_raycast.collider
	if collider is Interactable and collider.can_interact:

		type = Type.ACTIVE

		if not collider.reticle_tooltip_text.is_empty():

			reticle_tooltip.show()
			reticle_tooltip.text = collider.reticle_tooltip_text

	else:

		type = Type.INACTIVE
		reticle_tooltip.hide()
		reticle_tooltip.text = ""


func _on_item_entered_preview(_node: Node) -> void:

	hide()


func _on_item_exited_preview(_node: Node) -> void:

	show()
