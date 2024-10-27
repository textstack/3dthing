extends Node3D

# Load the targets
@export var ghost = preload("res://models/targets/character_ghost.tscn")
var grave_pos: Array[Node3D] = []
@export var player: Node3D  # Reference to the player node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grave_pos = [$graves/grave, $graves/grave2, $graves/grave3, $graves/grave4, 
				$graves/grave5, $graves/grave6, $graves/grave7, $graves/grave8, 
				$graves/grave9, $graves/grave10, $graves/grave11, $graves/grave12, 
				$graves/grave13, $graves/grave14, $graves/grave15, $graves/grave16, 
				$graves/grave17, $graves/grave18, $graves/grave19, $graves/grave20]

	spawn_ghost()


func spawn_ghost():
	if grave_pos.size() > 0:
		var random_grave = grave_pos[randi() % grave_pos.size()]
		# Instance 
		var ghost_instance = ghost.instantiate()
		ghost_instance.global_transform.origin = random_grave.global_transform.origin + Vector3(0, 0.5, 0)
		
		# References
		ghost_instance.player = player
		ghost_instance.main_scene = self
		
		# Add the ghost
		add_child(ghost_instance)
		# Make the ghost look at the player
		ghost_instance.look_at_player()
