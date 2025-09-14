extends VehicleBody3D

var max_rpm := 450
var max_torque := 300
var turn_speed := 3
var turn_amount := 0.3

func _physics_process(delta: float) -> void:
	#$Camera3D.position = position
	
	var direction = Input.get_action_strength("Gas") - Input.get_action_strength("Brake")
	var steer_direciton = Input.get_action_strength("Left") - Input.get_action_strength("Right")
	
	var rpm_left = abs($wheel_rear_left.get_rpm())
	var rpm_right = abs($wheel_rear_right.get_rpm())
	var rpm = (rpm_left + rpm_right) / 2.0
	
	var torque = direction * max_torque * (1.0 - rpm / max_rpm)
	
	engine_force = torque
	steering = lerp(steering, steer_direciton * turn_amount, turn_speed * delta)
	
	if direction == 0:
		brake = 2
