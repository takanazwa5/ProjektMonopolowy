class_name Player extends CharacterBody3D


const ACCELERATION: float = 1.0
const DECELERATION: float = 1.0
const SPEED_WALKING : float = 2.5
const SPEED_CROUCHING : float = 1.5


var speed : float = SPEED_WALKING
var can_move_camera : bool = true
var can_move : bool = true


@onready var item_rig : ItemRig = %ItemRig
@onready var item_preview : ItemPreview = %ItemPreview
@onready var interaction_raycast : InteractionRaycast = %InteractionRaycast
@onready var camera : Camera3D = %Camera
@onready var hud : HUD = %HUD


func _init() -> void:

	GameManager.player = self


func _ready() -> void:

	item_preview.child_entered_tree.connect(_on_item_entered_preview)
	item_preview.child_exiting_tree.connect(_on_item_exited_preview)


func _unhandled_input(event: InputEvent) -> void:

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and can_move_camera:

		if event is InputEventMouseMotion:

			rotate_y(deg_to_rad(-event.relative.x) * 0.05)
			camera.rotate_x(deg_to_rad(-event.relative.y) * 0.05)
			camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))


func _physics_process(delta: float) -> void:

	# NOTE: Has to be done here because InputEventJoypadMotion is not registered when value stays still.
	var joy_x_axis_value: float = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var joy_y_axis_value: float = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	rotate_y(deg_to_rad(-joy_x_axis_value * 100.0) * delta)
	camera.rotate_x(deg_to_rad(-joy_y_axis_value * 100.0) * delta)
	camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	if not is_on_floor():

		velocity += get_gravity() * delta

	var input_dir : Vector2 = Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward")
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).limit_length()

	if direction and can_move:

		velocity.x = move_toward(velocity.x, direction.x * speed, ACCELERATION)
		velocity.z = move_toward(velocity.z, direction.z * speed, ACCELERATION)

	else:

		velocity.x = move_toward(velocity.x, 0.0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0.0, DECELERATION)

	move_and_slide()


func _on_item_entered_preview(_node: Node) -> void:

	can_move = false
	can_move_camera = false


func _on_item_exited_preview(_node: Node) -> void:

	can_move = true
	can_move_camera = true
