extends KinematicBody

enum {
	IDLE,
	ALERT
}

var health = 200
var target
var state = IDLE
const TURN_SPEED = 2
const MOVE_SPEED = 5


onready var rayCast = $RayCast
onready var eyes = $Eyes
onready var shoot_timer = $ShootTimer

func _ready():
	pass

func _on_SightRange_body_entered(body):
	if body.is_in_group("Player"):
		state = ALERT
		target = body
		shoot_timer.start()

func _on_Timer_timeout():
	if rayCast.is_colliding():
		var hit = rayCast.get_collider()
		if hit.is_in_group("Player"):
			print("Hit!!")

func _process(delta):
	
	if health <= 0:
		queue_free()
	if state == ALERT:
		eyes.look_at(target.translation, Vector3.UP)
		rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
		move_and_slide(-transform.basis.z * MOVE_SPEED)
