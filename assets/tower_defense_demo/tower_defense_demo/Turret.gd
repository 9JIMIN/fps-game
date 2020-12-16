extends Area2D

signal shoot

var target = null
var can_shoot = true

func flash():
	$Gun/Flash.show()
	yield(get_tree().create_timer(0.09), "timeout")
	$Gun/Flash.hide()
	
func shoot():
	if can_shoot:
		emit_signal("shoot", $Gun/Muzzle.global_transform)
		flash()
		can_shoot = false
		yield(get_tree().create_timer(0.15), "timeout")
		can_shoot = true

func find_closest_target():
	var units = get_overlapping_areas()
	if units.size() > 0:
		var closest = units[0].get_parent()
		for unit in units:
			if position.distance_to(unit.global_position) < position.distance_to(closest.global_position):
				closest = unit.get_parent()
		target = closest
	else:
		target = null
		
func _process(delta):
	if !target:
		find_closest_target()
	if target:
		$Gun.rotation = (target.global_position - position).angle() + PI/2
		shoot()

func _on_Turret_area_exited(area):
	if area.get_parent() == target:
		target = null
