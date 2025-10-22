extends Control

@onready var audioBTN = $optionsMenu/dualMargins/leftMargin/leftVBox/btnBoxSub/btnBox/audioBTN
@onready var backBTN = $optionsMenu/dualMargins/leftMargin/leftVBox/btnMargin/btnBox/backBTN


func _ready():
	audioBTN.pressed.connect(_on_audio_pressed)
	backBTN.pressed.connect(_on_back_pressed)

func _on_audio_pressed():
	get_tree().change_scene_to_file("res://scenes/main menu/audio-menu.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main menu/main-menu.tscn")
	
