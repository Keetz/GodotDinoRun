extends Node2D

export(float) var rampup = 1.05

onready var score_text = get_node("Score")
onready var game_over_text = get_node("GameOver")
onready var obstacle_manager = get_node("PlayArea/ObstacleManager")
onready var character = get_node("PlayArea/Character")

onready var speed_increase_timer = Timer.new()
onready var spawn_timer = Timer.new()


func set_score():
	score_text.set_score(int(obstacle_manager.distance_traveled / 20))

func _ready():
	$Background/ForestLayer.connect("timeout", self, "_on_background_timeout")
	set_process_input(false)
	add_child(spawn_timer)
	character.connect("died", self, "_on_character_died")

	spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
	# long wait time before first obstacle
	spawn_timer.set_wait_time(2)
	spawn_timer.start()
	
	game_over_text.hide()
	
	score_text.reset_score()
	set_score()
	
func reset_spawn_timer():
	spawn_timer.set_wait_time(get_random_timeout())
	spawn_timer.start()

func get_random_timeout():
	return 0.6 + randf() * 400 / obstacle_manager.move_speed
	
func _process(delta):
	set_score()
	
func game_restart():
	get_tree().paused = false
	game_over_text.hide()
	set_process_input(false)
	set_process(true)
	
	for obstacle in obstacle_manager.get_children():
		obstacle_manager.remove_child(obstacle)
		obstacle.queue_free()
	
	obstacle_manager.distance_traveled = 0
	score_text.reset_score()
	set_score()
	
	character.revive()
	
	spawn_timer.set_wait_time(4)
	spawn_timer.start()
	

	obstacle_manager.move_speed = 400
	$Background/SkyLayer.scroll_time = 500
	$Background/SeaLayer.scroll_time = 100
	$Background/ForestLayer.scroll_time = 3
	$Foreground/DirtLayer.scroll_time = 2
	
func _on_spawn_timer_timeout():
	obstacle_manager.spawn_obstacle()
	reset_spawn_timer()
	
func _on_character_died():
	set_process(false)
	game_over_text.show()
	spawn_timer.stop()
	speed_increase_timer.stop()
	set_process_input(true)
	get_tree().paused = true
	
func _on_background_timeout():
	if obstacle_manager.move_speed < 900:
		obstacle_manager.move_speed *= rampup
		$Background/ForestLayer.scroll_time /= rampup
		$Background/SkyLayer.scroll_time /= rampup
		$Background/SeaLayer.scroll_time /= rampup
		$Foreground/DirtLayer.scroll_time /= rampup
	
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		game_restart()
	