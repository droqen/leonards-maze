extends Node2D

@onready var maze = $"../TileMap"
@onready var spr = $Sprite2D
@export var leonard : bool = false
var wobble : int = 0
@export var face : int = 0
var movingdir : int = -1

func _physics_process(_delta: float) -> void:
	wobble = (wobble+1) % 34
	match face:
		0:
			spr.frame = 40
			spr.flip_h = false
		1:
			spr.frame = 44
		2:
			spr.frame = 40
			spr.flip_h = true
		3:
			spr.frame = 42
	if leonard: spr.frame += 10
	if wobble > 20: spr.frame += 1
	if leonard:
		if randf() < 0.01:
			movingdir = (face+2)%4
	else:
		if Input.is_action_just_pressed("ui_right"): movingdir = 0
		if Input.is_action_just_pressed("ui_up"): movingdir = 1
		if Input.is_action_just_pressed("ui_left"): movingdir = 2
		if Input.is_action_just_pressed("ui_down"): movingdir = 3
	if try_move_dir(face):
		wobble += 1
	if movingdir != face:
		if can_turn_dir(movingdir):
			var cell = maze.local_to_map(position)
			face = movingdir
	
	if position.x <=  -5: position.x = 215-1
	if position.x >= 215: position.x =  -5+1

func isfree(cell:Vector2i) -> bool:
	return maze.get_cell_atlas_coords(cell) == Vector2i.ZERO

func can_turn_dir(dir:int) -> bool:
	var cell = maze.local_to_map(position)
	var tocenter : Vector2i = maze.map_to_local(cell) - position
	match dir:
		0,2: if abs(tocenter.y) > 5: return false
		1,3: if abs(tocenter.x) > 5: return false
	match dir:
		0: if (isfree(cell + Vector2i.RIGHT)): return true;
		1: if (isfree(cell + Vector2i.UP)):    return true;
		2: if (isfree(cell + Vector2i.LEFT)):  return true;
		3: if (isfree(cell + Vector2i.DOWN)):  return true;
	return false

func try_move_dir(dir:int) -> bool:
	var cell = maze.local_to_map(position)
	var tocenter : Vector2i = maze.map_to_local(cell) - position
	match dir:
		0,2: if tocenter.y != 0: position.y += sign(tocenter.y)
		1,3: if tocenter.x != 0: position.x += sign(tocenter.x)
	match dir:
		0: if (tocenter.x > 0
			or isfree(cell + Vector2i.RIGHT)):
					position.x += 1; return true;
		1: if (tocenter.y < 0
			or isfree(cell + Vector2i.UP)):
					position.y -= 1; return true;
		2: if (tocenter.x < 0
			or isfree(cell + Vector2i.LEFT)):
					position.x -= 1; return true;
		3: if (tocenter.y > 0
			or isfree(cell + Vector2i.DOWN)):
					position.y += 1; return true;
	return false; # nomove.
