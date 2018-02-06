extends Node2D

onready var score_text = get_node("Score")
onready var obstacle_manager = get_node("PlayArea/ObstacleManager")

onready var spawn_timer = Timer.new()

var score = 0

func set_score():
	score_text.set_score(int(score))

func _ready():
	add_child(spawn_timer)
	spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
	# long wait time before first obstacle
	spawn_timer.set_wait_time(4)
	spawn_timer.start()
	
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
	
func _on_spawn_timer_timeout():
	obstacle_manager.spawn_obstacle()
	reset_spawn_timer()