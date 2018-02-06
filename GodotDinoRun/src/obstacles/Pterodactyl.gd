extends Node2D

onready var animation = get_node("AnimationPlayer")

enum state {FLYING}

func _ready():
	run()

func run():
	state = FLYING
	animation.play("PterodactylFly")