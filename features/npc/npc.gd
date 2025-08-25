class_name NPC extends CharacterBody3D


const ROTATION_SPEED: float = 10.0
const WALKING_SPEED: float = 1.5


var target_node: Node3D


@onready var navigation_agent_3d: NavigationAgent3D = %NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree


func _ready() -> void:

	navigation_agent_3d.target_reached.connect(_on_target_reached)
	navigation_agent_3d.navigation_finished.connect(_on_navigation_finished)


func _physics_process(delta: float) -> void:

	if navigation_agent_3d.is_navigation_finished():

		velocity.x = move_toward(velocity.x, 0, WALKING_SPEED)
		velocity.z = move_toward(velocity.z, 0, WALKING_SPEED)

	else:

		# Rotation based on movement direction magic
		var direction: Vector3 = (navigation_agent_3d.get_next_path_position() - position).normalized()
		var left_axis : Vector3 = Vector3.UP.cross(direction)
		var rotation_basis : Quaternion = Basis(left_axis, Vector3.UP, direction).get_rotation_quaternion()
		var model_scale : Vector3 = transform.basis.get_scale()
		transform.basis = Basis(transform.basis.get_rotation_quaternion().slerp(rotation_basis, delta * ROTATION_SPEED)).scaled(model_scale)
		velocity.x = direction.x * WALKING_SPEED
		velocity.z = direction.z * WALKING_SPEED

	move_and_slide()


func _process(_delta: float) -> void:

	var blend_pos: float = remap(velocity.length(), 0.0, WALKING_SPEED, 0.0, 1.0)
	animation_tree.set(&"parameters/blend_position", blend_pos)


func navigate_to_node(node: Node3D) -> void:

	if target_node == node: return
	target_node = node
	print("target changed to: %s" % node)
	navigation_agent_3d.target_position = node.global_position


func _on_target_reached() -> void:

	pass
	#print("target reached")


func _on_navigation_finished() -> void:

	var target_pos: Vector3 = navigation_agent_3d.target_position
	target_pos.y = global_position.y
	var target_transform: Transform3D = transform.looking_at(target_pos, Vector3.UP, true)
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, ^"transform", target_transform, 0.25)
	if target_node is Node3D:

		print("navigation finished - target: %s" % target_node)
		target_node = null

	#print("navigation finished")
	#print("distance to target: %s" % navigation_agent_3d.distance_to_target())
