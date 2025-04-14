class_name Player extends CharacterBody3D


const SPEED_WALKING : float = 2.5
const SPEED_CROUCHING : float = 1.5


var speed : float = SPEED_WALKING
var can_move_camera : bool = true
var can_move : bool = true


@onready var item_rig : ItemRig = %ItemRig
@onready var item_preview : ItemPreview = %ItemPreview
@onready var interaction_raycast : InteractionRaycast = %InteractionRaycast
@onready var item_preview_prompt : Control = %ItemPreviewPrompt
@onready var camera : Camera3D = %Camera
@onready var reticle : Reticle = %Reticle
@onready var hud : CanvasLayer = %HUD


func _init() -> void:

	GameManager.player = self


func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

		if not can_move_camera:

			return

		rotate_y(-event.relative.x * 0.001)
		camera.rotate_x(-event.relative.y * 0.001)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))


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
