class_name PlayerIdleState extends State


@onready var player : Player = owner


func enter() -> void:

	%HeadbobAnimationPlayer.pause()


func input_event(event: InputEvent) -> void:

	if event.is_action_pressed("crouch"):

		transition.emit(%CrouchingState)


func update(_delta: float) -> void:

	if not is_zero_approx(player.velocity.length()):

		transition.emit(%WalkingState)
