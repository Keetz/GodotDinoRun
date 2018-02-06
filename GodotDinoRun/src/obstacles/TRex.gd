extends "res://src/obstacles/obstacle.gd"

onready var animation = get_node("AnimationPlayer")

enum state {RUNNING}

# TODO: interesting -> collision with empty polygon shape crashes the program

func _ready():
	spawn_height = -12
	run()

func run():
	state = RUNNING
	animation.play("TRexRun")