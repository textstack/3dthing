extends Node3D

# Load the targets
@export var ghost = preload("res://models/targets/character_ghost.tscn")
@export var vampire = preload("res://models/targets/character_vampire.tscn")
@export var skeleton = preload("res://models/targets/character_skeleton.tscn")
@export var zombie = preload("res://models/targets/character_zombie.tscn")

var targets = []
var active_targets: Array[Node3D] = []
var grave_pos: Array[Node3D] = []
var occupied_graves = {}

@export var player: Node3D  # Reference to the player node
@export var max_targets = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Load the targets and grave positions
	targets = [ghost, vampire, skeleton, zombie]
	grave_pos = [$graves/grave, $graves/grave2, $graves/grave3, $graves/grave4, 
				$graves/grave5, $graves/grave6, $graves/grave7, $graves/grave8, 
				$graves/grave9, $graves/grave10, $graves/grave11, $graves/grave12, 
				$graves/grave13, $graves/grave14, $graves/grave15, $graves/grave16, 
				$graves/grave17, $graves/grave18, $graves/grave19, $graves/grave20]
	for grave in grave_pos:
		occupied_graves[grave] = false  # Mark each grave as unoccupied
	spawn_rand()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
		
func spawn_rand():
	if grave_pos.size() > 0:
		var rand_grave: Node3D
		var attempts = 0
		var max_attempts = 20  # Prevent infinite loop

		# Keep selecting a random grave until an unoccupied one is found
		while attempts < max_attempts:
			rand_grave = grave_pos[randi() % grave_pos.size()]
			if not occupied_graves[rand_grave]:  # Check if the grave is unoccupied
				break  # Found an unoccupied grave
			attempts += 1

		if attempts == max_attempts:
			print("No available graves to spawn a target.")
			return  # Exit if no available grave was found

		# Mark the grave as occupied
		occupied_graves[rand_grave] = true
	
		# Choose a random target
		var rand_target = targets[randi() % targets.size()]

		# Instantiate
		var target_instance = rand_target.instantiate()
		target_instance.global_transform.origin = rand_grave.global_transform.origin + Vector3(0, 0.5, 0)

		# Set references
		target_instance.player = player
		target_instance.main_scene = self
		add_child(target_instance)
		max_targets

		# Make the target look at the player
		target_instance.look_at_player()
		

func _on_spawn_timer_timeout() -> void:
	spawn_rand()
