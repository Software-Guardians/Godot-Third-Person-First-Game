extends Node3D
@onready var ball:PackedScene=preload("res://objects/ball.tscn") 
@onready var character: Node3D = $"Character-male-d"
@onready var balls: Node3D = $balls
@onready var menu_canvas_layer: CanvasLayer = $UiMain/Control/MenuCanvasLayer
@onready var button_restart: Button = $UiMain/Control/MenuCanvasLayer/VBoxContainer/ButtonRestart
@onready var game_canvas_layer: CanvasLayer = $UiGame/GameCanvasLayer
@onready var label_score: Label = $UiGame/GameCanvasLayer/LabelScore
@onready var label_time: Label = $UiGame/GameCanvasLayer/LabelTime
@onready var ball_timer: Timer = $ballTimer
@onready var button_play: Button = $UiMain/Control/MenuCanvasLayer/VBoxContainer/ButtonPlay
@onready var button_resume: Button = $UiMain/Control/MenuCanvasLayer/VBoxContainer/ButtonResume
@onready var main_timer: Timer = $MainTimer
const GAME_OVER_SCENE = preload("res://scenes/user-interface/gameOverScene.tscn")



@export var ball_position_list:=[]

func _ready() -> void:
	print("başladı")
	GameManager.game_start.connect(game_started)
	GameManager.game_paused.connect(is_paused)
	GameManager.game_stoped.connect(is_stoped)
	GameManager.ball_remove.connect(ball_remove)
	GameManager.ball_kicked.connect(add_ball_to_label)
func game_started():
	GameManager.is_game_active=true
	game_canvas_layer.visible=true
	menu_canvas_layer.visible=false
	label_score.text="Kicked Balls: "+ str(GameManager.kicked_ball_number) 
	label_time.text="Time: "+ str(GameManager.default_Time) 
	for ball in balls.get_children():
		balls.remove_child(ball)
		ball.queue_free()
func ball_remove():
	GameManager.last_kicked_ball.queue_free()
func add_ball_to_label():
	label_score.text="Kicked Balls: "+ str(GameManager.kicked_ball_number) 

func ball_create():
	while GameManager.is_game_active:
		if ball_position_list.size()==10:
			break
		var ball_absolute_position:=Vector3(randi_range(-22,22),2,randi_range(-22,22))
		if ball_position_list.has(ball_absolute_position):
			print("aynı toptan var")
			continue
		
		var ball_approximately_position:={
			"x_down":ball_absolute_position.x-1,
			"x_up":ball_absolute_position.x+1,
			"z_down":ball_absolute_position.z-1,
			"z_up":ball_absolute_position.z+1
		}
		var character_position:= character.global_position
		var control:bool=((character_position.x>=ball_approximately_position["x_down"])and (character_position.x<=ball_approximately_position["x_up"]) and (character_position.z>=ball_approximately_position["z_down"])and (character_position.z<=ball_approximately_position["z_up"]))
		if not control:
			var ball_instance=ball.instantiate()
			balls.add_child(ball_instance)
			ball_instance.global_position=ball_absolute_position

			ball_position_list.append(ball_absolute_position)
			break
		else :

			continue


func _on_ball_timer_timeout() -> void:
	ball_create()
	

func _on_button_play_pressed() -> void:
	GameManager.start_game()	
	ball_timer.start()
	main_timer.start()
	main_timer.paused=false
func _on_button_exit_pressed() -> void:
	get_tree().quit()

func is_paused() -> void:
	GameManager.is_game_active=false
	game_canvas_layer.visible=false
	menu_canvas_layer.visible=true
	button_restart.visible=true
	ball_timer.paused=true
	button_play.visible=false
	button_resume.visible=true
	main_timer.paused=true
func _on_button_restart_pressed() -> void:
	GameManager.start_game()
	ball_timer.start()
	GameManager.is_game_active=true
	ball_timer.paused=false
	main_timer.start()
	main_timer.paused=false
func _on_button_resume_pressed() -> void:
	ball_timer.paused=false
	GameManager.resume_game()
	GameManager.is_game_active=true
	game_canvas_layer.visible=true
	menu_canvas_layer.visible=false
	button_restart.visible=false
	button_play.visible=false
	button_resume.visible=true
	main_timer.paused=false

func _on_main_timer_timeout() -> void:
	if GameManager.time>1:
		GameManager.time-=1
		label_time.text="Time: "+ str(GameManager.time) 

	else:
		GameManager.stop_game()
func is_stoped():
	var my_window=GAME_OVER_SCENE.instantiate()
	get_tree().root.add_child(my_window)
	GameManager.is_game_active=false
	game_canvas_layer.visible=false
	menu_canvas_layer.visible=true
	button_restart.visible=true
	ball_timer.paused=true
	button_play.visible=false
	button_resume.visible=false
	main_timer.paused=true
