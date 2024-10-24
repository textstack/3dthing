extends MeshInstance3D


var alpha = 1.0

@onready var blood_particle = $BloodParticle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dup_material = material_override.duplicate()
	material_override = dup_material


func init(pos1, pos2):
	var draw_mesh = ImmediateMesh.new()
	mesh = draw_mesh
	draw_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material_override)
	draw_mesh.surface_add_vertex(pos1)
	draw_mesh.surface_add_vertex(pos2)
	draw_mesh.surface_end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	alpha -= delta * 3.5
	material_override.albedo_color.a = alpha
	
func _trigger_particles(pos, gun_pos, enemy_hit):
	if enemy_hit:
		blood_particle.position = pos
		blood_particle.look_at(gun_pos)
		blood_particle.emitting = true
	else:
		#could add terrain perticles but would probably have to change collision layers and masks for enemys
		pass


func _on_timer_timeout() -> void:
	queue_free()
