extends CharacterBody3D

const SPEED = 5
const SPRINT_SPEED = 10
const JUMP_VELOCITY = 4

var sens = 0.2

var can_jump = false

var raycast_test = preload("res://shot.tscn")
# Bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

# Store the initial camera position
var initial_camera_position: Vector3

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Store the initial camera position
	initial_camera_position = $Camera3D.transform.origin
	

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
	
	# Determine current speed based on sprint input
	var curr_speed = SPEED  # Default to normal speed
	if Input.is_action_pressed("Sprint"):
		curr_speed = SPRINT_SPEED  # Switch to sprint speed
	
	var vel = Vector3(0, 0, 0)
	if direction:
		vel.x = direction.x * curr_speed
		vel.z = direction.z * curr_speed
	else:
		vel.x = 0
		vel.z = 0
	
	velocity.x = damp(velocity.x, vel.x, delta)
	velocity.z = damp(velocity.z, vel.z, delta)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	$Camera3D.transform.origin = initial_camera_position + _headbob(t_bob)
	
	move_and_slide()
	

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("shoot"):
		_shoot()
		
func _shoot() -> void:
	var camera = $Camera3D # Gets Camera of player
	var space_state = camera.get_world_3d().direct_space_state # Tales camera 3d state
	var screen_center = get_viewport().size / 2 # Finds center of that camera
	var origin = camera.project_ray_origin(screen_center) # finds origin of ray from that center
	var end = origin + camera.project_ray_normal(screen_center) * 1000 # finds the end
	var query = PhysicsRayQueryParameters3D.create(origin, end) # creates ray
	query.collide_with_bodies = true # sets ray collision to true
	var result = space_state.intersect_ray(query) 
	if result: # checks if ray hit stuff
		_test_raycast(result.get("position"))
	
	
func _test_raycast(position: Vector3) -> void:
	var instance = raycast_test.instantiate() # this func just creates the test ball to show the raycast works
	get_tree().root.add_child(instance)
	instance.global_position = position
	await get_tree().create_timer(3).timeout
	instance.queue_free()
	

# Function to calculate head bob
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
