extends Node2D

var blonk : int = 0

func _physics_process(delta: float) -> void:
	position = (get_viewport().size as Vector2 - Vector2(660,660)) * 0.5
	scale = Vector2(3,3)
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://maze_1/main.tscn")
	blonk = (blonk+1)%56
	$press_space_to_play.visible = blonk < 28
	$Sprite2D.visible = !$press_space_to_play.visible
