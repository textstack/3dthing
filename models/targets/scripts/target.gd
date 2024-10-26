extends CharacterBody3D
class_name target

var player: Node3D
var main_scene: Node3D
var shot = preload("res://enemyCollider.tscn")
@onready var animation_tree: AnimationTree = $AnimationTree
			
func _ready():
	if player:
		look_at_player()
	
	# Connect all body parts 
	connect_area_signals(self)

func _process(delta):
	look_at_player()

func look_at_player():
	if player:
		var direction = player.global_transform.origin - global_transform.origin
		direction.y = 0
		if direction != Vector3.ZERO:
			look_at(global_transform.origin + direction, Vector3.UP)

func play_death_animation() -> void:
	animation_tree.set("parameters/conditions/die", true)

# Recursive function for body parts
func connect_area_signals(node: Node):
	for child in node.get_children():
		if child is Area3D:
			child.body_entered.connect(_on_area_3d_body_entered)
		elif child.has_method("get_children"):
			# Recursively go through children 
			connect_area_signals(child)

# Handler for when a body enters an Area3D
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player or body.name == "enemyCollider":
		Global.score += 1
		play_death_animation()
		await get_tree().create_timer(1.0).timeout
		queue_free()
		main_scene.spawn_rand()
