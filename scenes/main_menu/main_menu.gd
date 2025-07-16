class_name MainMenu extends Control


const GAME_SCENE : PackedScene = preload("uid://daih55gqatj4l")


@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton
@onready var beer_can_opening_sound: AudioStreamPlayer = %BeerCanOpeningSound


func _ready() -> void:

	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_start_button_pressed() -> void:

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	beer_can_opening_sound.play()
	await beer_can_opening_sound.finished
	get_tree().change_scene_to_packed(GAME_SCENE)


func _on_quit_button_pressed() -> void:

	get_tree().quit()
