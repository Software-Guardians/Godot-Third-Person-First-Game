extends CharacterBody3D
@onready var camera_3d_controller: Node3D = $Camera3DController
@onready var character: Node3D = $character
@onready var animation_player: AnimationPlayer = $character/AnimationPlayer


@export var sens:=0.05
@export var speed:=10
@export var rotation_speed := 0.1
@export var gravity:=30
@export var jump_velocity:=10
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
	if Input.is_action_pressed(&"walk-back") or Input.is_action_pressed(&"walk-front"):
		target_character_rotation_y*=0.5
		animation_player.play(&"walk")
	if target_character_rotation_y!=0:
		animation_player.play(&"walk")
	elif input_dir.x==0 and input_dir.y==0:
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
		
	
		
	
	
