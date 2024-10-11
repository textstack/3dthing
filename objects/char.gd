extends CharacterBody3D

const SPEED = 10
const JUMP_VELOCITY = 7

var sens = 0.2

var can_jump = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens))
		$Camera3D.rotate_x(deg_to_rad(-event.relative.y * sens))

func damp(from, to, delta):
	return lerp(from, to, 1 - exp(-18 * delta))

func _physics_process(delta: float) -> void:
	if is_on_floor():
		can_jump = true
	else:
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("Jump") and can_jump:
		can_jump = false
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var vel = Vector3(0, 0, 0)
	if direction:
		vel.x = direction.x * SPEED
		vel.z = direction.z * SPEED
	else:
		vel.x = 0
		vel.z = 0
	
	velocity.x = damp(velocity.x, vel.x, delta)
	velocity.z = damp(velocity.z, vel.z, delta)
	
	move_and_slide()
