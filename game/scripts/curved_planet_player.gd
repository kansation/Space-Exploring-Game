extends CharacterBody3D

@export var planet_center := Vector3.ZERO
@export var move_speed := 4.0
@export var mouse_sensitivity := 0.0025
@export var gravity := 9.8
@export var jump_height := 1.2
@export_range(1.0, 89.0, 1.0) var max_floor_angle_degrees := 42.0

@onready var head: Node3D = $Head
var look_pitch := 0.0

func _ready() -> void:
	floor_max_angle = deg_to_rad(max_floor_angle_degrees)
	floor_snap_length = 0.25
	up_direction = (global_position - planet_center).normalized()
	if up_direction == Vector3.ZERO:
		up_direction = Vector3.UP
	_align_to_surface()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_object_local(Vector3.UP, -event.relative.x * mouse_sensitivity)
		look_pitch = clamp(look_pitch - event.relative.y * mouse_sensitivity, -1.45, 1.45)
		head.rotation.x = look_pitch
	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	var up := (global_position - planet_center).normalized()
	up_direction = up
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var movement := (transform.basis * Vector3(input_vector.x, 0.0, input_vector.y)).normalized()
	if is_on_floor() and movement != Vector3.ZERO:
		movement = movement.slide(get_floor_normal()).normalized()
	var radial_speed := velocity.dot(up)
	if is_on_floor():
		radial_speed = 0.0
		if Input.is_action_just_pressed("jump"):
			radial_speed = sqrt(2.0 * gravity * jump_height)
	else:
		radial_speed -= gravity * delta
	velocity = movement * move_speed + up * radial_speed
	move_and_slide()
	_align_to_surface()

func _align_to_surface() -> void:
	var up := (global_position - planet_center).normalized()
	var forward := -global_transform.basis.z
	forward = (forward - up * forward.dot(up)).normalized()
	if forward.length_squared() > 0.001:
		global_transform.basis = Basis.looking_at(forward, up)
	up_direction = up
