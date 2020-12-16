extends KinematicBody

enum {
	IDLE,
	ALERT
}
const max_health = 100
var health = max_health
var target
var state = IDLE
const TURN_SPEED = 2
const MOVE_SPEED = 5
const GRAVITY = 20
var gravity_vec = Vector3()
var movement = Vector3()

onready var aim = $AimCast
onready var eyes = $Eyes
onready var muzzle = $Muzzle
onready var shoot_timer = $ShootTimer
onready var bullet = preload("res://assets/Bullet.tscn")

onready var health_bar2d = $HealthBar3D/Viewport/HealthBar2D
onready var bar_green = preload("res://assets/progressbar/green.png")
onready var bar_yellow = preload("res://assets/progressbar/yellow.png")
onready var bar_red = preload("res://assets/progressbar/red.png")

func _ready():
	pass

func _on_SightRange_body_entered(body):
	if body.is_in_group("Player"):
		state = ALERT
		target = body
		shoot_timer.start()

func _on_SightRange_body_exited(body):
	if body.is_in_group("Player") and state == ALERT:
		state = IDLE
	
func _on_Timer_timeout():
	if aim.is_colliding() and state == ALERT:
		var hit = aim.get_collider()
		if hit.is_in_group("Player"):
			var b = bullet.instance()
			muzzle.add_child(b)
			b.look_at(aim.get_collision_point(), Vector3.UP)
			b.shoot = true

func update_bar():
	health_bar2d.texture_progress = bar_green
	if health < max_health * 0.75:
		health_bar2d.texture_progress = bar_yellow
	if health < max_health * 0.25:
		health_bar2d.texture_progress = bar_red
	health_bar2d.value -= 10

func _physics_process(delta):
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * GRAVITY * delta
	else:
		gravity_vec = -get_floor_normal()
	
	if state == ALERT:
		eyes.look_at(target.translation, Vector3.UP)
		rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
		movement = -transform.basis.z * MOVE_SPEED
		movement.y = gravity_vec.y
		movement = move_and_slide(movement, Vector3.UP)
	
	if health <= 0:
		queue_free()


