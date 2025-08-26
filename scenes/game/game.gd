class_name Game extends Node


@onready var level: Level = %Level
@onready var player: Player = %Player


func _ready() -> void:

	player.item_rig.child_entered_tree.connect(_on_item_entered_rig)
	player.item_rig.child_exiting_tree.connect(_on_item_exited_rig)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	print("Game scene ready.")


func _process(_delta: float) -> void:

	DebugPanel.add_property(Engine.get_frames_per_second(), "FPS", 1000)


func _on_item_entered_rig(_node: Node) -> void:

	level.counter.can_interact = true


func _on_item_exited_rig(_node: Node) -> void:

	level.counter.can_interact = false
