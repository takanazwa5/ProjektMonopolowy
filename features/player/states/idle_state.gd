class_name PlayerIdleState extends State


@onready var player : Player = owner


func enter() -> void:

	%HeadbobAnimationPlayer.stop(true)
	%Camera.create_tween().tween_property(%Camera, "position", Vector3.ZERO, 0.1).from_current()


func input_event(event: InputEvent) -> void:

	if event.is_action_pressed("crouch") and player.can_move:

		transition.emit(%CrouchingState)


func update(_delta: float) -> void:

	if not is_zero_approx(player.velocity.length()):

		transition.emit(%WalkingState)


func physics_update(_delta: float) -> void:

	pass


func exit() -> void:

	pass
