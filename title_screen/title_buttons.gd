extends VBoxContainer

const background = preload("res://title_screen/title_background.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# When start button is pressed start the game
func _on_start_pressed() -> void:
	Global.reset()
	get_tree().change_scene_to_file("res://areas/main.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()
