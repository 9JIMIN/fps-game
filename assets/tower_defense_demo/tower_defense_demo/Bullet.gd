extends Area2D

var velocity = Vector2.ZERO
var speed = 500

func _physics_process(delta):
	position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_area_entered(area):
	area.get_parent().take_damage(2)
	queue_free()
