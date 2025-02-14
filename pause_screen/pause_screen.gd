extends Control
# Resume hides the pause screen
func resume():
	hide()
	get_tree().paused = false

# Pause shows the pause screen
func pause():
	show()
	get_tree().paused = true

# Detects if the pause button was clicked
func testClick():
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()

# Functions set to conenct correct functions with buttons
func _on_resume_pressed() -> void:
	resume()

# Function for quit button
func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
