extends Node

@export var car_node: Car
@export var path_follow: PathFollow3D
@export var ai_speed := 70.0

func _physics_process(delta: float) -> void:
	# Avanzar en el camino
	path_follow.progress += ai_speed * delta

	# Poner inputs simulados para el coche
	var target = path_follow.global_transform.origin
	var direction = (target - car_node.global_transform.origin).normalized()
	var forward = -car_node.global_transform.basis.z

	var steering_amount = forward.signed_angle_to(direction, Vector3.UP)

	car_node.speed_input = car_node.acceleration
	car_node.rotate_input = clamp(steering_amount, -deg_to_rad(car_node.steering), deg_to_rad(car_node.steering))

	car_node.RightWheel.rotation.y = car_node.rotate_input
	car_node.LeftWheel.rotation.y = car_node.rotate_input
