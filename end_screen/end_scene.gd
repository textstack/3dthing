extends Control

# Reference your Label nodes from the scene
@onready var score_label = $ScoreLabel  # Replace with your label node name
@onready var accuracy_label = $AccuracyLabel  # Replace with your label node name
@onready var highscore_label = $HighscoreLabel  # Replace with your label node name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	## Create label settings
	#var label_settings = LabelSettings.new()
	#label_settings.font_size = 40
	#var custom_font = load("res://fonts/KiwiSoda.ttf")
	#label_settings.font = custom_font
	#
	## Apply settings to all labels
	#score_label.label_settings = label_settings
	#accuracy_label.label_settings = label_settings
	#highscore_label.label_settings = label_settings
	
	# Calculate accuracy
	var accuracy = 0.0
	if Global.attacks > 0:
		accuracy = (float(Global.score) / float(Global.attacks)) * 100
	
	# Update highscore if needed
	if Global.score > Global.highscore:
		Global.highscore = Global.score
	
	# Update the labels
	score_label.text = "Score: " + str(Global.score)
	accuracy_label.text = "Accuracy: " + str(snapped(accuracy, 0.1)) + "%"
	highscore_label.text = "Highscore: " + str(Global.highscore)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_restart_pressed() -> void:
	Global.reset()
	get_tree().change_scene_to_file("res://areas/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
