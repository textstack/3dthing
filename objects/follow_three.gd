extends PathFollow3D

@export var ghost = preload("res://models/targets/character_ghost.tscn")
var empty = true
var player: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_speed = 4.0
	progress += move_speed * delta
	if get_child_count() == 0:
		empty = true
		spawn_ghost()

func spawn_ghost():
	if empty:
		progress = randi() * 50
		var target_instance = ghost.instantiate()
		target_instance.player = get_parent().get_parent().get_node("character-digger")
		add_child(target_instance)
		empty = false
