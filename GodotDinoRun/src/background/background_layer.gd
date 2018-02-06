extends Node2D

export(PackedScene) var background_scene

func _ready():
	instance_backgrounds()
	
func instance_backgrounds():
	for i in range(2):
		var background_instance = background_scene.instance()
		add_child(background_instance)
		