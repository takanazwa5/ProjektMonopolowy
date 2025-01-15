class_name PlayerCrouchingState extends State


@onready var player : Player = owner


func enter() -> void:

	%CrouchAnimationPlayer.play("Crouch")


func update(_delta: float) -> void:

	if Input.is_action_pressed("crouch") or %CrouchCast.is_colliding():

		return

	if is_zero_approx(player.velocity.length()):

		transition.emit(%IdleState)

	else:

		transition.emit(%WalkingState)


func exit() -> void:

	%CrouchAnimationPlayer.play_backwards("Crouch")
