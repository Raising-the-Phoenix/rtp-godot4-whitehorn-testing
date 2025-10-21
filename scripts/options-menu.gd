extends Control

@onready var backBTN = $optionsMenu/dualPNL/leftPNL/leftVBox/btnMargin/btnBox/backBTN

func _ready():
	backBTN.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main-menu.tscn")
