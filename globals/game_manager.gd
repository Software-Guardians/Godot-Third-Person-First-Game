extends Node
var kicked_ball_number:=0
var default_Time=10
var time=5

var last_kicked_ball:RigidBody3D
var is_game_active:=false
signal game_start
signal game_paused
signal game_stoped
signal game_resumed
signal ball_remove
signal ball_kicked
func add_kicked_ball(removed_ball:RigidBody3D,character_scene):
	kicked_ball_add_one()
	var kick_timer=Timer.new()
	kick_timer.wait_time=1.5
	kick_timer.one_shot=true
	kick_timer.timeout.connect(func():
		timer_outed(removed_ball))
	character_scene.add_child(kick_timer)
	kick_timer.start()
	print(str(removed_ball.get("ball_first_position")))
func kicked_ball_add_one():
	kicked_ball_number+=1
	ball_kicked.emit()
func reset_kicked_ball():
	kicked_ball_number=0
func timer_outed(removed_ball):

	last_kicked_ball=removed_ball	
	ball_remove.emit()
func start_game():
	emit_signal("game_start")
	time=default_Time
func stop_game():
	emit_signal("game_stoped")
func pause_game():
	emit_signal("game_paused")
func resume_game():
	emit_signal("game_resumed")
