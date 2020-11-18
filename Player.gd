extends KinematicBody

# move speed
var speed = 20
var jump = 10

# mouse speed
var mouse_sensitivity = 0.5

# acceleration
var h_acc = 6
var air_acc = 1
var normal_acc = 6
var gravity = 20

var full_contact = false

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

onready var camera = $CamRoot
onready var ground_check = $GroundCheck
onready var aimcast = $CamRoot/Camera/AimCast
onready var muzzle = $CamRoot/Gun/Muzzle

onready var bullet = preload("res://Bullet.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg2rad(-70), deg2rad(80))
		
func _physics_process(delta):
	
	direction = Vector3()
	
	full_contact = ground_check.is_colliding()
	
	if Input.is_action_just_pressed("shoot"):
		if aimcast.is_colliding():
			var b = bullet.instance()
			muzzle.add_child(b)
			b.look_at(aimcast.get_collision_point(), Vector3.UP)
			b.shoot = true
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acc = air_acc
	elif is_on_floor() and full_contact:
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
	
	direction = direction.normalized()
	h_velocity = lerp(h_velocity, direction * speed, h_acc * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide(movement, Vector3.UP)
