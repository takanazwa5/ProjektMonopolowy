class_name Player extends CharacterBody3D


const SPEED_WALKING : float = 2.5
const SPEED_CROUCHING : float = 1.5


var speed : float = SPEED_WALKING
var can_move_camera : bool = true
var can_move : bool = true

var _input_dir : Vector2 = Vector2()
var _direction : Vector3 = Vector3()

var item_in_hand : Item
var item_in_preview : Item


@onready var item_rig : Node3D = %ItemRig
@onready var item_preview : Node3D = %ItemPreview
@onready var interaction_raycast : InteractionRaycast = %InteractionRaycast


func _ready() -> void:

	Main.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

		if item_in_preview is Item:

			item_preview.rotate_y(event.relative.x * 0.001)
			item_preview.rotate_x(event.relative.y * 0.001)

		if not can_move_camera:

			return

		rotate_y(-event.relative.x * 0.001)
		%Camera.rotate_x(-event.relative.y * 0.001)
		%Camera.rotation.x = clampf(%Camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	if item_in_hand is Item and event.is_action_pressed("drop_item"):

		item_in_hand.reparent(Main.level, true)
		item_in_hand.freeze = false
		item_in_hand = null
		interaction_raycast.enabled = true

	if item_in_preview is Item:

		if event.is_action_pressed("interact"):

			item_in_preview.reparent(item_rig, false)
			item_in_hand = item_in_preview
			item_in_preview = null
			can_move_camera = true
			can_move = true
			item_preview.rotation = Vector3.ZERO

		elif event.is_action_pressed("drop_item"):

			item_in_preview.reparent(Main.level)
			item_in_preview.global_transform = item_in_preview.origin
			item_in_preview = null
			can_move_camera = true
			can_move = true
			interaction_raycast.enabled = true
			item_preview.rotation = Vector3.ZERO


func _physics_process(delta: float) -> void:

	if not is_on_floor():

		velocity += get_gravity() * delta

	if not can_move:

		return

	var input_dir : Vector2 = Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward")
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	_input_dir = input_dir
	_direction = direction

	if direction:

		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

	else:

		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _process(_delta: float) -> void:

	DebugPanel.add_property(_input_dir, "input_dir", 2)
	DebugPanel.add_property(_direction, "direction", 3)
	DebugPanel.add_property(can_move, "can_move", 6)
	DebugPanel.add_property(can_move_camera, "can_move_camera", 7)
	DebugPanel.add_property(item_in_hand, "item_in_hand", 8)
	DebugPanel.add_property(item_in_preview, "item_in_preview", 9)
