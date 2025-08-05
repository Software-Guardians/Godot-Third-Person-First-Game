extends Window
@onready var ball_label: Label = $VBoxContainer/BallLabel

func _ready() -> void:
	GameManager.game_stoped.connect(game_over)
func _on_button_pressed() -> void:
	hide()
func game_over():
	popup_centered()
