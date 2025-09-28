extends Node3D
class_name Car

@onready var CarModel: Node3D = $Car
@onready var CarBody: MeshInstance3D = $Car/Body
@onready var Ball: RigidBody3D = $Ball
@onready var RightWheel: MeshInstance3D = $Car/Body/FrontRightWheel
@onready var LeftWheel: MeshInstance3D = $Car/Body/FrontLeftWheel
@onready var DriftTimer: Timer = $DriftTimer
@onready var BoostTimer: Timer = $BoostTimer

var acceleration = 70.0
var steering = 12.0
var turn_speed = 5.0
var body_tilt = 30

var speed_input = 0
var rotate_input = 0

var drifting = false
var drift_direction = 0
var min_drift = false
var boost = 1
var drift_boost = 1.75

func _physics_process(delta: float) -> void:
	CarModel.transform.origin = Ball.transform.origin
	Ball.apply_central_force(-CarModel.global_transform.basis.z * speed_input * boost)
	
func _process(delta: float) -> void:
	RightWheel.rotation.y = rotate_input
	LeftWheel.rotation.y = rotate_input

	if drifting:
		var drift_amount = 0
		drift_amount += Input.get_action_strength("Left") - Input.get_action_strength("Right")
		drift_amount *= deg_to_rad(steering * 0.55)
		rotate_input = drift_direction + drift_amount

	if Ball.linear_velocity.length() > 0.75:
		rotate_car(delta)
	
func rotate_car(delta):
	var new_basis = CarModel.global_transform.basis.rotated(CarModel.global_transform.basis.y, rotate_input)
	CarModel.global_transform.basis = CarModel.global_transform.basis.slerp(new_basis, turn_speed * delta)
	CarModel.global_transform = CarModel.global_transform.orthonormalized()
	var t = -rotate_input * Ball.linear_velocity.length() / body_tilt
	CarBody.rotation.z = lerp(CarBody.rotation.z, t, 10 * delta)
	
func start_drift():
	drifting = true
	min_drift = false
	drift_direction = rotate_input
	DriftTimer.start()
	
func stop_drift():
	print(min_drift)
	if min_drift:
		boost = drift_boost
		BoostTimer.start()
	drifting = false
	min_drift = false
	
func _on_drift_timer_timeout() -> void:
	if drifting:
		min_drift = true
	
func _on_boost_timer_timeout() -> void:
	boost = 1.0
