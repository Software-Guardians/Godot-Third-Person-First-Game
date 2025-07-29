extends Node
var kicked_ball_number:=0
var time=200
var last_kicked_ball:RigidBody3D

func add_kicked_ball(removed_ball:RigidBody3D):
	kicked_ball_number+=1	
	var kick_timer=Timer.new()
	kick_timer.wait_time=1.5
	kick_timer.one_shot=true
	kick_timer.timeout.connect(func():
		timer_outed(removed_ball))
	kick_timer.start()
func reset_kicked_ball():
	kicked_ball_number=0
func timer_outed(removed_ball):
	last_kicked_ball=removed_ball
