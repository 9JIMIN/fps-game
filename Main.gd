extends Node

onready var enemy = preload("res://enemy/Enemy.tscn")

func _ready():
	$Control/Retry.hide()

func _on_Player_die():
	$Control/Retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $Control/Retry.visible:
		get_tree().reload_current_scene()
