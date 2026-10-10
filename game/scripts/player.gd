extends CharacterBody3D

@export var move_speed := 4.0
@export var mouse_sensitivity := 0.0025
@export var gravity := 9.8

@onready var head: Node3D = $Head

var look_pitch := 0.0

func _ready() -> void:
	_capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_rotate_view(event.relative)
	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_release_mouse()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_capture_mouse()

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var movement := (transform.basis * Vector3(input_vector.x, 0.0, input_vector.y)).normalized()
	velocity.x = movement.x * move_speed
	velocity.z = movement.z * move_speed

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	move_and_slide()

func _rotate_view(relative_motion: Vector2) -> void:
	rotate_y(-relative_motion.x * mouse_sensitivity)
	look_pitch = clamp(look_pitch - relative_motion.y * mouse_sensitivity, -1.45, 1.45)
	head.rotation.x = look_pitch

func _capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
