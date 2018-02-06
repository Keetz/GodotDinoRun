extends Node2D

onready var score_text = get_node("Score")

onready var spawn_timer = Timer.new()

var score = 0

func set_score():
	score_text.set_score(int(score))

func _ready():
	spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
	score_text.reset_score()
	set_score()
	
	
	
func _process(delta):
	score += delta * 1000
	set_score()