extends Node3D

const SPEED = 40

@onready var ray = $RayCast3D
@onready var particle = $GPUParticles3D
@onready var mesh = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#bullet path
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	
	
	if ray.is_colliding():
		mesh.visible = false
		particle.emitting = true
		ray.enabled = false
		if ray.get_collider().is_in_group("enemy"):
			ray.get_collider().hit()
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_timer_timeout():
	queue_free()
