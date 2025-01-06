class_name MainMenu extends Control


const GAME_SCENE : PackedScene = preload("res://main.tscn")


func _ready() -> void:

	%StartButton.pressed.connect(_on_start_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)


func _on_start_button_pressed() -> void:

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	%BeerCanOpeningSound.play()
	await %BeerCanOpeningSound.finished
	get_tree().change_scene_to_packed(GAME_SCENE)


func _on_quit_button_pressed() -> void:

	get_tree().quit()
