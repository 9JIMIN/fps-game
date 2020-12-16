extends PathFollow2D

var speed = 50
var health = 50
var max_health = 50
	
func _process(delta):
	offset += speed * delta
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func take_damage(amount):
	health -= amount
	$HealthDisplay.update_healthbar(health)
	if health <= 0:
		queue_free()