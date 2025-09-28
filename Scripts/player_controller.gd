extends Node

@export var car: NodePath
@onready var car_node = get_node(car)

func _process(delta: float) -> void:
	var acceleration = car_node.acceleration
	var steering = car_node.steering

	# Inputs del jugador
	car_node.speed_input = (Input.get_action_strength("Up") - Input.get_action_strength("Down")) * acceleration
	car_node.rotate_input = deg_to_rad(steering) * (Input.get_action_strength("Left") - Input.get_action_strength("Right"))

	car_node.RightWheel.rotation.y = car_node.rotate_input
	car_node.LeftWheel.rotation.y = car_node.rotate_input

	# Drift
	if Input.is_action_pressed("Drift") and not car_node.drifting and car_node.rotate_input != 0 and car_node.speed_input > 0:
		car_node.start_drift()
	elif car_node.drifting and (Input.is_action_just_released("Drift") or car_node.speed_input < 1):
		car_node.stop_drift()
