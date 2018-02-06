extends Node2D

onready var score_numbers = [
	get_node("1"),
	get_node("10"),
	get_node("100"),
	get_node("1000"),
	get_node("10000"),
	get_node("100000"),
	get_node("1000000"),
]

onready var start_position = position

func _ready():
	pass
	
# TODO: decimal size is bad name
func calculate_decimal_value(number, decimal_size):
	return int(fmod(number / decimal_size, 10))
	
# TODO there are some weird rounding errors in here...

func reset_score():
	for score_number in score_numbers:
		score_number.hide()
	
func set_score(score):
	var score_size = len(str(score))
	for i in range(score_size):
		var decimal_size = int(pow(10, i))
		score_numbers[i].set_frame(calculate_decimal_value(score, decimal_size))
		score_numbers[i].show()
		score_numbers[i].set_position(Vector2(-i * 32, 0))
	position = start_position + Vector2(score_size / 2 * 32, 0) 
		
	