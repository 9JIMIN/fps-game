extends RigidBody

var shoot = false
const DAMAGE = 10
const SPEED = 10

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)

func _on_Area_body_entered(body):
	if body.is_in_group('Enemy') or body.is_in_group("Player"):
		body.update_bar()
		body.health -= DAMAGE
		queue_free()
		if body.health <= 0 and body.is_in_group("Player"):
			body.emit_signal("die")
			body.queue_free()
	else:
		queue_free()
