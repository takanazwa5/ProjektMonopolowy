class_name PlayerWalkingState extends State


@onready var player : Player = owner


func enter() -> void:

	%HeadbobAnimationPlayer.play("Headbob")
	%HeadbobAnimationPlayer.speed_scale = 1.5
	player.speed = Player.SPEED_WALKING


func input_event(event: InputEvent) -> void:

	if event.is_action_pressed("crouch") and player.can_move:

		transition.emit(%CrouchingState)


func update(_delta: float) -> void:

	if is_zero_approx(player.velocity.length()):

		transition.emit(%IdleState)


func exit() -> void:

	%HeadbobAnimationPlayer.speed_scale = 1.0
