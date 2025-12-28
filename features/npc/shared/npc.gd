class_name NPC extends CharacterBody3D


signal interaction(line_id: String)


const ROTATION_SPEED: float = 10.0
const WALKING_SPEED: float = 1.5


var _target_node: Node3D
var _navigation_interrupted: bool = false


@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var state_machine: StateMachine = %StateMachine
@onready var info_label: Label3D = %StateLabel


func _ready() -> void:

	info_label.visible = OS.is_debug_build()
	nav_agent.navigation_finished.connect(_on_navigation_finished)
	Global.dialogue.dialogue_started.connect(_on_dialogue_started)
	Global.dialogue.dialogue_ended.connect(_on_dialogue_ended)


func _physics_process(delta: float) -> void:

	if is_instance_valid(_target_node) and not _navigation_interrupted:

		var next_path_pos: Vector3 = nav_agent.get_next_path_position()
		var direction: Vector3 = global_position.direction_to(next_path_pos)
		velocity = direction * WALKING_SPEED

		# Rotate model towards direction
		var target_rotation: float = direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
		rotation.y = lerp_angle(rotation.y, target_rotation, delta * ROTATION_SPEED)

	else: velocity = Vector3.ZERO

	move_and_slide()


func _process(_delta: float) -> void:

	# Adjust animation speed based on speed
	var blend_pos: float = remap(velocity.length(), 0.0, WALKING_SPEED, 0.0, 1.0)
	animation_tree.set(&"parameters/walk_blend/blend_position", blend_pos)

	info_label.text = "vel: %.2f\n%s" % [velocity.length(), state_machine.current_state.name]


func interact(event: InputEvent) -> void:

	if not event.is_action_pressed(&"interact"): return
	interaction.emit("npc_basia_001")


func navigate_to_node(node: Node3D) -> void:

	_target_node = node
	nav_agent.target_position = _target_node.global_position


func _on_navigation_finished() -> void:

	var target_pos: Vector3 = nav_agent.target_position
	target_pos.y = global_position.y
	var target_transform: Transform3D = transform.looking_at(target_pos, Vector3.UP, true)
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, ^"transform", target_transform, 0.25)
	_target_node = null


func _on_dialogue_started() -> void:

	_navigation_interrupted = true


func _on_dialogue_ended() -> void:

	_navigation_interrupted = false
