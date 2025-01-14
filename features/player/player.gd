class_name Player extends CharacterBody3D


const SPEED : float = 2.5


func _ready() -> void:

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

		rotate_y(-event.relative.x * 0.001)
		%Camera.rotate_x(-event.relative.y * 0.001)
		%Camera.rotation.x = clampf(%Camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir : Vector2 = Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward")
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	DebugPanel.add_property(input_dir, "input_dir", 1)
	DebugPanel.add_property(direction, "direction", 2)

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _process(_delta: float) -> void:

	DebugPanel.add_property(%StateMachine.state.name, "State", 3)
