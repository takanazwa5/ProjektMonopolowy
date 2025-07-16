class_name MainMenu extends Control


@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton
@onready var beer_can_opening_sound: AudioStreamPlayer = %BeerCanOpeningSound


func _ready() -> void:

	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_start_button_pressed() -> void:

	beer_can_opening_sound.play()
	var game_scene: PackedScene = load("uid://daih55gqatj4l")
	if beer_can_opening_sound.playing:

		await beer_can_opening_sound.finished

	var error: Error = get_tree().change_scene_to_packed(game_scene)
	if not error == OK:

		printerr("Failed changing main menu to game scene")

	else:

		print("Main scene instantiated.")


func _on_quit_button_pressed() -> void:

	get_tree().quit()
