extends Node2D

var npitch : float = 0.39
var n2pitch : float = 0.66
var waiting_for_intro_done : bool = true

var degrade : int = 0

func _ready() -> void:
	$intro.play()
	$intro.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	$player.process_mode = Node.PROCESS_MODE_PAUSABLE
	$player._physics_process(0)
	$leonard.process_mode = Node.PROCESS_MODE_PAUSABLE
	$leonard._physics_process(0)
	
	$noise.volume_db = -50
	$noise2.volume_db = -50
	scale = Vector2(3,3)
	position = (get_viewport().size as Vector2 - scale*220) * 0.5
	
	$player.hide()
	$leonard.hide()
	$TileMap.hide()
	await get_tree().create_timer(1.39).timeout
	$TileMap.show()
	await get_tree().create_timer(1.39).timeout
	#await get_tree().create_timer(2.78).timeout
	$player.show()
	await get_tree().create_timer(1.39).timeout
	$leonard.show()
	await get_tree().create_timer(1.39).timeout
	if waiting_for_intro_done:
		stop_waiting()

func stop_waiting() -> void:
	waiting_for_intro_done = false
	$noise.volume_db = -50
	$noise.play()
	$noise2.volume_db = -50
	$noise2.play()
	get_tree().paused = false
	$leonards_maze.hide()
	$player.face = 0
	$leonard.face = 0

func _physics_process(delta: float) -> void:
	if waiting_for_intro_done:
		if $intro.get_playback_position() > 5.50:
			stop_waiting()
	if $noise.volume_db > -20:
		scale.x *= 0.9999
		scale.y *= 0.9999
	else:
		scale = Vector2(3,3)
	position = (get_viewport().size as Vector2 - scale*220) * 0.5
	if $noise.volume_db < 0:
		$noise.volume_db += delta
	$noise.pitch_scale = lerp($noise.pitch_scale,npitch,0.03)
	if $noise2.volume_db < 0:
		$noise2.volume_db += delta
	$noise2.pitch_scale = lerp($noise2.pitch_scale,n2pitch,0.03)
	if randf() < 0.01: npitch = randf_range(.25,.5) + randf_range(.25,.5)
	if randf() < 0.01: n2pitch = randf_range(.25,.5) + randf_range(.25,.5)
