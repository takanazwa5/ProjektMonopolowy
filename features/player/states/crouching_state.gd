class_name PlayerCrouchingState extends State


@onready var player : Player = owner


func enter() -> void:

	%CrouchAnimationPlayer.play("Crouch")
	player.speed = Player.SPEED_CROUCHING


func update(_delta: float) -> void:

	if is_zero_approx(player.velocity.length()):

		if not Input.is_action_pressed("crouch") and not %CrouchCast.is_colliding():

			transition.emit(%IdleState)

		%HeadbobAnimationPlayer.stop(true)
		%Camera.create_tween().tween_property(%Camera, "position", Vector3.ZERO, 0.1).from_current()

	else:

		if not Input.is_action_pressed("crouch") and not %CrouchCast.is_colliding():

			transition.emit(%WalkingState)

		if not %HeadbobAnimationPlayer.is_playing():

			%HeadbobAnimationPlayer.play("Headbob")


func exit() -> void:

	%CrouchAnimationPlayer.play_backwards("Crouch")
