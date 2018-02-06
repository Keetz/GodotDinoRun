extends Area2D

signal died

const JUMP_HEIGHT = 100

onready var animation = get_node("AnimationPlayer")

var tween = Tween.new()

enum state {RUNNING, JUMPING, DEAD}

var current_state = state.RUNNING


func _ready():
	add_child(tween)
	
	set_process_input(true)
	
	connect("area_entered", self, "_on_something_entered")
	
	run()

func _input(event):
	if event.is_action_pressed("ui_select"):
		if current_state == state.RUNNING:
			jump()

func run():
	if current_state != state.DEAD:
		current_state = state.RUNNING
		animation.play("CavemanRun")

func jump():
	current_state = state.JUMPING
	
	var origin_pos = self.position
	
	animation.play("CavemanJump")
	var jump_anim_length = animation.current_animation_length
	
	tween.interpolate_property(self, "position", origin_pos, Vector2(origin_pos.x, origin_pos.y - JUMP_HEIGHT), jump_anim_length / 2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	
	tween.interpolate_property(self, "position", Vector2(origin_pos.x, origin_pos.y - JUMP_HEIGHT), origin_pos, jump_anim_length / 2, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	
	tween.remove_all()
	
	run()
	

func revive():
	current_state = state.RUNNING
	animation.play("CavemanRun")

func die():
	current_state = state.DEAD
	
	animation.play("CavemanDie")
	yield(animation, "animation_finished")
	
	emit_signal("died")
	
func _on_something_entered(other_area):
	die()