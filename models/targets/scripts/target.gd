extends CharacterBody3D
class_name target

var player: Node3D
var main_scene: Node3D
var shot = preload("res://enemyCollider.tscn")
signal target_shot
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
			# Only connect if not already connected
			if not child.is_connected("body_entered", Callable(self, "_on_area_3d_body_entered")):
				child.body_entered.connect(_on_area_3d_body_entered)
		elif child.has_method("get_children"):
			# Recursively go through children 
			connect_area_signals(child)

# Handler for when a body enters an Area3D
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player or body.name == "enemyCollider":
		Global.score += 1
		play_death_animation()
		
		# Disconnect signals to prevent further interactions
		disconnect_area_signals(self)
		
		# Wait for the death animation to complete
		await get_tree().create_timer(1.0).timeout
		
		emit_signal("target_shot", self)
		# Free the target from the scene
		queue_free()
		
# Disconnect area signals for cleanup
func disconnect_area_signals(node: Node):
	for child in node.get_children():
		if child is Area3D:
			if child.is_connected("body_entered", Callable(self, "_on_area_3d_body_entered")):
				child.body_entered.disconnect(_on_area_3d_body_entered)
		elif child.has_method("get_children"):
			# Recursively go through children 
			disconnect_area_signals(child)
		
