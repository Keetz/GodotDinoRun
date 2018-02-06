extends Node2D

signal player_died

export var jump_height = 100

onready var animation = get_node("AnimationPlayer")

var tween = Tween.new()

enum state {RUNNING, JUMPING, DEAD}

func _ready():
	add_child(tween)
	
	set_process_input(true)
	
	run()

func _input(event):
	if event.is_action_pressed("ui_select"):
		if state != JUMPING:
			jump()

func run():
	state = RUNNING
	animation.play("CavemanRun")

func jump():
	state = JUMPING
	
	var origin_pos = self.position
	
	animation.play("CavemanJump")
	var jump_anim_length = animation.current_animation_length
	
	tween.interpolate_property(self, "position", origin_pos, Vector2(origin_pos.x, origin_pos.y - jump_height), jump_anim_length / 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	
	tween.interpolate_property(self, "position", Vector2(origin_pos.x, origin_pos.y - jump_height), origin_pos, jump_anim_length / 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	
	tween.remove_all()
	
	run()

func die():
	state = DEAD
	
	animation.play("CavemanDie")
	yield(animation, "animation_finished")
	
	emit_signal("player_died")