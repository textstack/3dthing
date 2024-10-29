extends CharacterBody3D

const SPEED = 5
const SPRINT_SPEED = 10
const JUMP_VELOCITY = 4

var sens = 0.2
var can_jump = false
var raycast_test = preload("res://enemyCollider.tscn") 

# Bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.05
var t_bob = 0.0

# Gun Variables
@onready var gun_ani = $"Skeleton3D/arm-right/Revolver/Revovler_38/AnimationPlayer"

# Camera enum for switching views
const CAMERA = preload("res://models/character/CameraEnum.gd")
var current_cam = CAMERA.FIRST

# Store initial camera position
var initial_camera_position: Vector3
@onready var anim_tree = $AnimationTree

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	initial_camera_position = $FIRST.transform.origin
	anim_tree.active = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens))
		$FIRST.rotate_x(deg_to_rad(-event.relative.y * sens))
		$AIM.rotate_x(deg_to_rad(-event.relative.y * sens))

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
	
	if direction.length() > 0:
		anim_tree.set("parameters/walking/blend_amount", 1.0) # Activate walking
	else:
		anim_tree.set("parameters/walking/blend_amount", 0.0) # Deactivate walking
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	$FIRST.transform.origin = initial_camera_position + _headbob(t_bob)
	
	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		$Skeleton3D/UserInterface/CanvasLayer/EscapeMenu.pause()
	
	if Input.is_action_just_pressed("shoot"):
		if !gun_ani.is_playing():
			gun_ani.play("shoot")
			_shoot()
			get_tree().create_timer(0.3)

func _shoot() -> void:
	$shot_sound.play()
	Global.attacks += 1
	var camera
	if (current_cam == CAMERA.FIRST):
		camera = $FIRST
	if (current_cam == CAMERA.AIM):
		camera = $AIM
	var space_state = camera.get_world_3d().direct_space_state
	var screen_center = get_viewport().get_size() / 2
	var origin = camera.project_ray_origin(screen_center)
	var end = origin + camera.project_ray_normal(screen_center) * 1000
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	print(result)
	if result:
		_test_raycast(result.get("position"))
	else:
		print("You missed")

func _test_raycast(pos: Vector3) -> void:
	var instance = raycast_test.instantiate()
	var particles = instance.get_node("GPUParticles3D")
	get_tree().root.add_child(instance)
	instance.global_position = pos
	particles.emitting = true
	await get_tree().create_timer(.3).timeout
	instance.queue_free()

# Function to calculate head bob
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
