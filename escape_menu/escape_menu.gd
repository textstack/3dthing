extends Control

var showing = false


func _process(delta: float) -> void:
	if visible and not showing:
		showing = true
		return
	
	if Input.is_action_just_pressed("Quit") and showing:
		resume()


func pause():
	show()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func resume():
	hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	showing = false


func _on_continue_pressed() -> void:
	resume()


func _on_reset_pressed() -> void:
	resume()
	Global.reset()
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
