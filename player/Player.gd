extends KinematicBody

# move walk_speed
var walk_speed = 20
var jump = 10

# mouse walk_speed
var mouse_sensitivity = 0.5

# acceleration
var h_acc = 6
var air_acc = 1 # 공중에서 가속도
var normal_acc = 6
var gravity = 20

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

onready var camera = $CamRoot
onready var ground_check = $GroundCheck
onready var aimcast = $CamRoot/Camera/AimCast
onready var muzzle = $CamRoot/Gun/Muzzle
onready var shoot_ready = $CamRoot/Gun/Timer

onready var bullet = preload("res://assets/Bullet.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) # x는 오른쪽, y는 아래쪽.
		camera.rotation.x = clamp(camera.rotation.x, deg2rad(-90), deg2rad(90))
		
func _physics_process(delta):
	direction = Vector3()

	# 공중, 바닥 가속도 설정 
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acc = air_acc
	elif is_on_floor() and ground_check.is_colliding():
		gravity_vec = -get_floor_normal() * gravity
		h_acc = normal_acc
	else:
		gravity_vec = -get_floor_normal()
		h_acc = normal_acc
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		gravity_vec = Vector3.UP * jump
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	# 총알 쏘기 
	if Input.is_action_pressed("shoot") and aimcast.is_colliding() and shoot_ready.is_stopped():
		shoot_ready.start()
		var b = bullet.instance()
		muzzle.add_child(b)
		b.look_at(aimcast.get_collision_point(), Vector3.UP)
		b.shoot = true
	
	direction = direction.normalized()
	h_velocity = lerp(h_velocity, direction * walk_speed, h_acc * delta)
	movement.z = h_velocity.z + gravity_vec.z # x, z는 수평을 이루는 축.
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	movement = move_and_slide(movement, Vector3.UP)
