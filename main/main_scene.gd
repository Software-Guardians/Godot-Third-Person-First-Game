extends Node3D
@onready var ball:PackedScene=preload("res://objects/ball.tscn") 
@onready var character: Node3D = $"Character-male-d"
@onready var balls: Node3D = $balls
@export var ball_position_list:=[]

func _ready() -> void:
	print("başladı")



func ball_create():
	while true:
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
