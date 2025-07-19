class_name NPC extends CharacterBody3D


@onready var navigation_agent_3d: NavigationAgent3D = %NavigationAgent3D


func _ready() -> void:

	pass
	#navigation_agent_3d.target_position = GameManager.player.global_position


func _physics_process(_delta: float) -> void:

	#navigation_agent_3d.target_position = GameManager.player.global_position

	var direction : Vector3 = (navigation_agent_3d.get_next_path_position() - position).normalized()
	if direction:

		velocity.x = direction.x * Player.SPEED_WALKING
		velocity.z = direction.z * Player.SPEED_WALKING

	move_and_slide()
