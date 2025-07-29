extends CharacterBody3D
@onready var camera_3d_controller: Node3D = $Camera3DController
@onready var character: Node3D = $character
@onready var animation_player: AnimationPlayer = $character/AnimationPlayer
@onready var kickable_area: Area3D = $character/KickableArea
@onready var kick_timer: Timer = $character/KickTimer



@export var kick_cooldown:=true
@export var sens:=0.05
@export var speed:=10
@export var rotation_speed := 0.1
@export var gravity:=30
@export var jump_velocity:=10
@export var kick_strength:=1


var input_dir:Vector2=Vector2.ZERO
var target_character_rotation_y:float=0.0


func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens))
		camera_3d_controller.rotate_x(deg_to_rad(-event.relative.y*sens))
		camera_3d_controller.rotation.x=clamp(camera_3d_controller.rotation.x,deg_to_rad(-20),deg_to_rad(20))


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y-=gravity*delta
	if Input.is_action_just_pressed(&"jump") and is_on_floor():
		velocity.y=jump_velocity
	var input_dir=Input.get_vector(&"walk-right",&"walk-left",&"walk-back",&"walk-front")
	var direction=(transform.basis*Vector3(input_dir.x,0,input_dir.y)).normalized()
	target_character_rotation_y=(Input.get_action_strength(&"walk-left")-Input.get_action_strength(&"walk-right"))
	if (Input.is_action_pressed(&"walk-back") or Input.is_action_pressed(&"walk-front")) and not animation_player.current_animation=="attack-kick-left":
		target_character_rotation_y*=0.5
		animation_player.play(&"walk")
	if target_character_rotation_y!=0 and not animation_player.current_animation=="attack-kick-left":
		animation_player.play(&"walk")
	elif input_dir.x==0 and input_dir.y==0 and not animation_player.current_animation=="attack-kick-left":
		animation_player.play(&"idle")
	target_character_rotation_y=deg_to_rad(target_character_rotation_y*30)

	character.rotation.y=lerp_angle(character.rotation.y,target_character_rotation_y,rotation_speed)
	
	if direction:

		velocity.x=direction.x*speed
		velocity.z=direction.z*speed
	else :
		velocity.x=move_toward(velocity.x,0,speed)
		velocity.z=move_toward(velocity.z,0,speed)
	move_and_slide()	
	if Input.is_action_just_pressed(&"kick") and kick_cooldown:
		kick_timer.start()
		animation_player.play(&"attack-kick-left")
		kick_cooldown=false
		attempt_kick()

func _on_timer_timeout() -> void:
	kick_cooldown=true
func attempt_kick():
	var bodies=kickable_area.get_overlapping_bodies()
	if bodies.is_empty():
		return
	var closest_ball:RigidBody3D=null
	var closest_distance:=INF
	for body in bodies:
		if body is RigidBody3D and body.is_in_group("balls"):
			if is_on_front(body):
				print("is_on_front")
				var dist=character.global_position.distance_to(body.global_position)
				if dist<closest_distance:
					closest_distance=dist
					closest_ball=body
	if closest_ball!=null:
		kick_ball(closest_ball)
func is_on_front(target:Node3D)->bool:
	var to_target=(target.global_position-character.global_position).normalized()
	var forward=character.global_transform.basis.z.normalized()
	var angle=forward.angle_to(to_target)
	return angle<deg_to_rad(60)
func kick_ball(ball: RigidBody3D):
	ball.sleeping = false
	var direction = (ball.global_position - character.global_position).normalized()
	direction.y = 0.3
	direction = direction.normalized()
	var impulse = direction * kick_strength
	ball.apply_central_impulse(impulse)
	GameManager.add_kicked_ball(ball)
