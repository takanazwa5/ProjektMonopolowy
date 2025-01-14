class_name PlayerIdleState extends State


@onready var player : Player = owner


func enter() -> void:

	%HeadbobAnimationPlayer.pause()


func update(_delta: float) -> void:

	if not is_zero_approx(player.velocity.length()):

		transition_to(%WalkingState)
