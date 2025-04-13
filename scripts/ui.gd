extends Control

@onready var score_value: RichTextLabel = %ScoreValue


func increase_score(value: int) -> void:
	var new_score = int(score_value.text) + value
	score_value.text = str(new_score)
