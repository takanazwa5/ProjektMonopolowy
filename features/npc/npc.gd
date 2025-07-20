class_name NPC extends CharacterBody3D


const ROTATION_SPEED: float = 10.0


@onready var navigation_agent_3d: NavigationAgent3D = %NavigationAgent3D


func _ready() -> void:

	navigation_agent_3d.target_reached.connect(_on_target_reached)
	navigation_agent_3d.navigation_finished.connect(_on_navigation_finished)


func _unhandled_input(_event: InputEvent) -> void:

	if OS.is_debug_build():

		if Input.is_physical_key_pressed(KEY_K):

			navigation_agent_3d.target_position = GameManager.level.counter.global_position

		elif Input.is_physical_key_pressed(KEY_L):

			navigation_agent_3d.target_position = GameManager.level.fridge.global_position


func _physics_process(delta: float) -> void:

	if navigation_agent_3d.is_navigation_finished():

		velocity.x = move_toward(velocity.x, 0, Player.SPEED_WALKING)
		velocity.z = move_toward(velocity.z, 0, Player.SPEED_WALKING)

	else:

		var direction: Vector3 = (navigation_agent_3d.get_next_path_position() - position).normalized()
		var left_axis : Vector3 = Vector3.UP.cross(direction)
		var rotation_basis : Quaternion = Basis(left_axis, Vector3.UP, direction).get_rotation_quaternion()
		var model_scale : Vector3 = transform.basis.get_scale()
		transform.basis = Basis(transform.basis.get_rotation_quaternion().slerp(rotation_basis, delta * ROTATION_SPEED)).scaled(model_scale)
		velocity.x = direction.x * Player.SPEED_WALKING
		velocity.z = direction.z * Player.SPEED_WALKING

	move_and_slide()


func _on_target_reached() -> void:

	pass
	#print("target reached")


func _on_navigation_finished() -> void:

	pass
	#print("navigation finished")
	#print("distance to target: %s" % navigation_agent_3d.distance_to_target())
