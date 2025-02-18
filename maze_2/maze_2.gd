extends Node2D

var pactimer : float = 0.0
var intro : bool = false
var blink : int = 50

func _ready() -> void:
	scale = Vector2(4,4)
	position = (get_viewport().size as Vector2 - scale*220) * 0.5

func _physics_process(delta: float) -> void:
	if not intro:
		if Input.is_action_just_pressed("ui_accept"):
			do_intro()
	blink += 1
	if blink == 10:
		$push.modulate.a = 0.0
		if not intro: $player.show()
	if blink >= 50:
		$push.modulate.a = 1.0
		if not intro: $player.hide()
		blink = -30
	position = (get_viewport().size as Vector2 - scale*220) * 0.5
	
const BAR : float = 1.37

const ELEMENTS = ["walls", "push", "title", "leonard", "player", "dots", "bigdots"]

var r : float = 0.00

func do_intro() -> void:
	intro = true
	$music2.play(0.0)
	$push.hide()
	$player.hide()
	
	await get_tree().create_timer(BAR).timeout
	$walls.show()
	await get_tree().create_timer(BAR).timeout
	$player.show()
	$music2.play()
	
	await get_tree().create_timer(BAR).timeout
	$leonard.show()
	await get_tree().create_timer(BAR).timeout
	$dots.show()
	#$music2.play()
	
	await get_tree().create_timer(BAR).timeout
	$bigdots.show()
	await get_tree().create_timer(BAR * 0.25).timeout
	$title.hide()
	$music2.play()
	
	while true:
		await get_tree().create_timer(BAR).timeout
		toggle_random_element()
		await get_tree().create_timer(BAR).timeout
		toggle_random_element()
		await get_tree().create_timer(BAR).timeout
		toggle_random_element()
		await get_tree().create_timer(BAR * 0.25).timeout
		toggle_random_element()
		if randf() < 0.50+r:
			await get_tree().create_timer(BAR * 0.25).timeout
			toggle_random_element()
			if randf() < 0.50+r:
				await get_tree().create_timer(BAR * 0.25).timeout
				toggle_random_element()
				if randf() < 0.25+r:
					$music2.bus = "Echo"
					var children = get_children()
					children.shuffle()
					for child in children:
						if child is Node2D and child.visible:
							child.hide()
							$music2.play($music2.get_playback_position() - BAR * 0.25)
							await get_tree().create_timer(BAR * 0.25).timeout
					$music2.bus = "Master"
					break
		toggle_random_element()
		toggle_random_element()
		toggle_random_element()
		toggle_random_element()
		r += 10.05
		$music2.play()

func toggle_random_element() -> void:
	var i = randi()%len(ELEMENTS)
	toggle_child(ELEMENTS[i])
func toggle_child(childname : String) -> void:
	var el = get_node(childname); el.visible = !el.visible
