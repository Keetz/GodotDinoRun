extends Node2D

onready var score_text = get_node("Score")
onready var game_over_text = get_node("GameOver")
onready var obstacle_manager = get_node("PlayArea/ObstacleManager")
onready var character = get_node("PlayArea/Character")

onready var game_nodes = [
	get_node("Background"),
	get_node("Foreground"),
]

onready var spawn_timer = Timer.new()

var score = 0

func set_score():
	score_text.set_score(int(score))

func _ready():
	set_process_input(false)
	add_child(spawn_timer)
	character.connect("died", self, "_on_character_died")
	spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
	# long wait time before first obstacle
	spawn_timer.set_wait_time(0.1)
	spawn_timer.start()
	
	game_over_text.hide()
	
	score_text.reset_score()
	set_score()
	
func reset_spawn_timer():
	spawn_timer.set_wait_time(get_random_timeout())
	spawn_timer.start()

func get_random_timeout():
	return 1 + 1 * randf()
	
func _process(delta):
	score += delta * 1000
	set_score()
	
func game_restart():
	get_tree().paused = false
	game_over_text.hide()
	set_process_input(false)
	set_process(true)
	
	for obstacle in obstacle_manager.get_children():
		obstacle_manager.remove_child(obstacle)
		obstacle.queue_free()
	
	score = 0
	score_text.reset_score()
	set_score()
	
	character.revive()
	
	spawn_timer.set_wait_time(4)
	spawn_timer.start()
	
	
func _on_spawn_timer_timeout():
	obstacle_manager.spawn_obstacle()
	reset_spawn_timer()
	
func _on_character_died():
	set_process(false)
	game_over_text.show()
	spawn_timer.stop()
	set_process_input(true)
	get_tree().paused = true
	
	
func _input(event):
	if event.is_action_pressed("ui_select"):
		game_restart()
	