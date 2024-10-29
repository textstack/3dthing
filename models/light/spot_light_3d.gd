extends SpotLight3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func flash():
	light_energy = randf()
	await get_tree().create_timer(randf_range(0.05, 1.0)).timeout
	flash()
