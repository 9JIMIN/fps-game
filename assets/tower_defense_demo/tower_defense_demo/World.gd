extends Node2D

var Unit = preload("res://Unit.tscn")
var Bullet = preload("res://Bullet.tscn")
	
func _on_Timer_timeout():
	var new_unit = Unit.instance()
	$Path2D.add_child(new_unit)	

func _on_Turret_shoot(xform):
	var bullet = Bullet.instance()
	bullet.position = xform.origin
	bullet.velocity = -xform.y * bullet.speed
	bullet.rotation = bullet.velocity.angle()
	add_child(bullet)
	