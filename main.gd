extends Node2D

var npitch : float = 0.39
var n2pitch : float = 0.66
var waiting_for_intro_done : bool = true

var degrade : int = 0

func _ready() -> void:
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	$player.process_mode = Node.PROCESS_MODE_PAUSABLE
	$player._physics_process(0)
	$leonard.process_mode = Node.PROCESS_MODE_PAUSABLE
	$leonard._physics_process(0)

func _physics_process(delta: float) -> void:
	if waiting_for_intro_done:
		print($intro.get_playback_position())
		if $intro.get_playback_position() > 5.50:
			waiting_for_intro_done = false
			$noise.volume_db = -50
			$noise.play()
			$noise2.volume_db = -50
			$noise2.play()
			get_tree().paused = false
			$leonards_maze.hide()
			$player.face = 0
			$leonard.face = 0
	position = (get_viewport().size as Vector2 - Vector2(660,660)) * 0.5
	scale = Vector2(3,3)
	$noise.volume_db += delta
	$noise.pitch_scale = lerp($noise.pitch_scale,npitch,0.03)
	$noise2.volume_db += delta
	$noise2.pitch_scale = lerp($noise2.pitch_scale,n2pitch,0.03)
	if randf() < 0.01: npitch = randf_range(.25,.5) + randf_range(.25,.5)
	if randf() < 0.01: n2pitch = randf_range(.25,.5) + randf_range(.25,.5)
