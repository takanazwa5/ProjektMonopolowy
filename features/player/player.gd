class_name Player extends CharacterBody3D


const SPEED_WALKING : float = 2.5
const SPEED_CROUCHING : float = 1.5


var speed : float = SPEED_WALKING
var can_move_camera : bool = true
var can_move : bool = true
var item_in_hand : Node3D
var item_in_preview : Node3D


@onready var item_rig : Node3D = %ItemRig
@onready var item_preview : Node3D = %ItemPreview
@onready var interaction_raycast : InteractionRaycast = %InteractionRaycast
@onready var item_preview_prompt : Control = %ItemPreviewPrompt
@onready var camera : Camera3D = %Camera


func _ready() -> void:

	Main.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	item_preview.child_entered_tree.connect(_on_item_entered_preview)
	item_preview.child_exiting_tree.connect(_on_item_exited_preview)
	item_rig.child_entered_tree.connect(_on_item_entered_rig)
	item_rig.child_exiting_tree.connect(_on_item_exited_rig)


func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

		if not item_in_preview == null:

			item_preview.rotate_y(event.relative.x * 0.001)
			item_preview.rotate_x(event.relative.y * 0.001)

		if not can_move_camera:

			return

		rotate_y(-event.relative.x * 0.001)
		camera.rotate_x(-event.relative.y * 0.001)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	if not item_in_hand == null and event.is_action_pressed("drop_item"):

		item_in_hand.queue_free()
		item_in_hand = null

	if not item_in_preview == null:

		if event.is_action_pressed("interact"):

			item_in_hand = item_in_preview
			item_preview.rotation = Vector3.ZERO
			item_in_preview.reparent(item_rig, false)

		elif event.is_action_pressed("drop_item"):

			item_in_preview.queue_free()
			item_preview.rotation = Vector3.ZERO


func _physics_process(delta: float) -> void:

	if not is_on_floor():

		velocity += get_gravity() * delta

	if not can_move:

		return

	var input_dir : Vector2 = Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward")
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:

		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

	else:

		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _process(_delta: float) -> void:

	DebugPanel.add_property(can_move, "can_move", 50)
	DebugPanel.add_property(can_move_camera, "can_move_camera", 51)
	DebugPanel.add_property(item_in_hand, "item_in_hand", 52)
	DebugPanel.add_property(item_in_preview, "item_in_preview", 53)


func _on_item_entered_preview(item: Node3D) -> void:

	SignalBus.item_entered_preview.emit()
	item_in_preview = item
	item_in_preview.transform = Transform3D()
	can_move_camera = false
	can_move = false
	item_preview_prompt.show()


func _on_item_exited_preview(_item: Node3D) -> void:

	item_in_preview = null
	can_move_camera = true
	can_move = true
	item_preview_prompt.hide()
	SignalBus.item_exited_preview.emit()


func _on_item_entered_rig(_item: Node3D) -> void:

	SignalBus.item_entered_rig.emit()


func _on_item_exited_rig(_item: Node3D) -> void:

	SignalBus.item_exited_rig.emit()
