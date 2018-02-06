extends Node2D

export(PackedScene) var background_scene
# export(PackedScene) var background_scene setget set_background_scene
export(int) var background_length = 800

export var flip = false

onready var tween = get_node("Tween")

export(float) var scroll_time = 100

var backgrounds = []
var amount_of_backgrounds

# TODO: signal timer here for change
signal timeout

func _ready():
	tween.connect("tween_completed", self, "_on_tween_completed")
	position = Vector2(-background_length/2, position.y)
	instance_backgrounds()
	var end_position = Vector2(background_length * amount_of_backgrounds, position.y)
	start_scrolling()
	tween.start()
	
#func set_background_scene(value):
#	background_scene = value
#	instance_backgrounds()
	
func instance_backgrounds():
	amount_of_backgrounds = int(ceil(get_viewport_rect().size.y / background_length)) + 3
	for i in range(amount_of_backgrounds):
		var background_instance = background_scene.instance()
		add_child(background_instance)
		if flip:
			background_instance.set_position(Vector2(-(i - 1) * background_length, 0))
		else:
			background_instance.set_position(Vector2(i * background_length, 0))
		backgrounds.append(background_instance)
		
func start_scrolling():
	emit_signal("timeout")
	if flip:
		position = Vector2(background_length, position.y)
		var end_position = Vector2(-(background_length * (amount_of_backgrounds - 4)), position.y)
		tween.interpolate_property(self, "position", position, end_position, scroll_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	else:
		position = Vector2(-background_length, position.y)
		var end_position = Vector2(background_length * (amount_of_backgrounds - 4), position.y)
		tween.interpolate_property(self, "position", position, end_position, scroll_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		
func _on_tween_completed(node, property):
	start_scrolling()
		
#func _process(delta):
#	var movement = Vector2(scroll_speed * delta, 0)
#	for background in backgrounds:
#		if scroll_speed > 0:
#			tween.interpolate_property(background, "position", background.get_position(),background.get_position() + movement, 1)
#			if background.get_position().x > background_length * amount_of_backgrounds:
#				background.set_position(Vector2(0, 0))
		
		
	
		