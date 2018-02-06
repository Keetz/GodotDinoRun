extends Node2D

export var move_speed = 400

onready var obstacle_scenes = [
	preload("res://src/obstacles/TRex.tscn"),
]

onready var spawn_point = Vector2(get_viewport_rect().size.x + 200, 0)

func _ready():
	pass
	
func spawn_obstacle():
	var obstacle_index = randi() % len(obstacle_scenes)
	var obstacle_instance = obstacle_scenes[obstacle_index].instance()
	obstacle_instance.set_position(spawn_point)
	add_child(obstacle_instance)
	
func _process(delta):
	var movement = Vector2(move_speed, 0) * delta
	for obstacle in get_children():
		obstacle.set_position(obstacle.get_position() - movement)
		if obstacle.get_position().x < -200:
			obstacle.queue_free()
	