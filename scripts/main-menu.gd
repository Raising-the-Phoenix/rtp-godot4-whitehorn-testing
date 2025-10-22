extends Control

func _ready():
	$mainMenu/dualPNL/leftPNL/leftVBox/btnMargin/btnBox/playBTN.pressed.connect(_on_play_pressed)
	$mainMenu/dualPNL/leftPNL/leftVBox/btnMargin/btnBox/optionsBTN.pressed.connect(_on_options_pressed)
	$mainMenu/dualPNL/leftPNL/leftVBox/btnMargin/btnBox/quitBTN.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/local_world.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/main menu/options-menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
