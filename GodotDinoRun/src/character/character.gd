extends Node2D

onready var animation = get_node("AnimationPlayer")

func _ready():
	animation.play("CavemanRun")
	
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_select"):
		animation.play("CavemanJump")
		yield(animation, "animation_finished")
		animation.play("CavemanRun")