class_name PlayerWalkingState extends State


@onready var player : Player = owner


func enter() -> void:

	%HeadbobAnimationPlayer.play("Headbob")


func update(_delta: float) -> void:

	if is_zero_approx(player.velocity.length()):

		transition_to(%IdleState)
