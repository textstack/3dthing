extends CharacterBody3D

const SPEED = 5
const SPRINT_SPEED = 10
const JUMP_VELOCITY = 4

var sens = 0.2

var can_jump = false

# Bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

# Store the initial camera position
var initial_camera_position: Vector3

#Bullets
var bullet = load("res://objects/bullet.tscn")
var bullet_trail = load("res://objects/bullet_trail.tscn")
var instance

#Guns
@onready var gun_ani = $Camera3D/Pistol/RootNode/AnimationPlayer
@onready var gun_barrel = $Camera3D/Pistol/RootNode/RayCast3D
@onready var smg_ani = $Camera3D/smg/AnimationPlayer
@onready var smg_barrel = $Camera3D/smg/RootNode/Barrel

@onready var aim_ray = $Camera3D/AimRay
@onready var aim_ray_end = $Camera3D/AimRayEnd

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
	
	_shoot_auto()
	
	move_and_slide()
	
# Function to calculate head bob
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	

func _shoot_pistols():
	# Shooting pistol
	if Input.is_action_pressed("Shoot"):
		if !gun_ani.is_playing():
			gun_ani.play("shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
			
func _shoot_auto():
	if Input.is_action_pressed("Shoot"):
		if !smg_ani.is_playing():
			smg_ani.play("shoot")
			instance = bullet_trail.instantiate()
			if aim_ray.is_colliding():
				instance.init(smg_barrel.global_position, aim_ray.get_collision_point())
				get_parent().add_child(instance)
				if aim_ray.get_collider().is_in_group("enemy"):
					aim_ray.get_collider().hit()
					instance._trigger_particles(aim_ray.get_collision_point(), smg_barrel.global_position, true)
				else:
					instance._trigger_particles(aim_ray.get_collision_point(), smg_barrel.global_position, false)
			
			else:
				instance.init(smg_barrel.global_position, aim_ray_end.global_position)
			get_parent().add_child(instance)
