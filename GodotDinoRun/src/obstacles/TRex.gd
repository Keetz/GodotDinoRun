extends "res://src/obstacles/obstacle.gd"

onready var animation = get_node("AnimationPlayer")

enum state {RUNNING}

func _ready():
	run()

func run():
	state = RUNNING
	animation.play("TRexRun")