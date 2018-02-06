extends "res://src/obstacles/obstacle.gd"

onready var animation = get_node("AnimationPlayer")

enum state {FLYING}

func _ready():
	spawn_height = -25
	
	run()

func run():
	state = FLYING
	animation.play("DragonFly")