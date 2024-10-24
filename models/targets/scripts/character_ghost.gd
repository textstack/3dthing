extends CharacterBody3D

var player: Node3D
var main_scene: Node3D
@onready var animation_tree: AnimationTree = $AnimationTree

var health = 2

signal ghost_hit

func _ready():
	if player:
		look_at_player()
		
	for area in get_children():
		if area is Area3D:
			area.body_entered.connect(_on_area_3d_body_entered)

func _process(delta):
	look_at_player()

func look_at_player():
	if player:
		# Get the direction to the player
		var direction = player.global_transform.origin - global_transform.origin
		direction.y = 0
		
		if direction != Vector3.ZERO:
			# Look at the player
			look_at(global_transform.origin + direction, Vector3.UP)

func play_death_animation() -> void:
	animation_tree.set("parameters/conditions/die", true)
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		play_death_animation()
		await get_tree().create_timer(1.0).timeout
		queue_free()
		main_scene.spawn_ghost()
		


func _on_area_3d_body_part_hit(dam: Variant) -> void:
	health -= dam
	ghost_hit.emit()
	if health <= 0:
		play_death_animation()
		await get_tree().create_timer(1.0).timeout
		queue_free()
		main_scene.spawn_ghost()

	
