extends Control

var prevAttacks = 0
var prevAttacks1 = 0
var score_label: Label
var timer_label: Label
var time_left: float = 30.0
var game_active: bool = true

func _ready() -> void:
	# Create label settings (create once, use for both labels)
	var label_settings = LabelSettings.new()
	label_settings.font_size = 50  # Change the font size as needed
	
	# Optional: Change the font by loading a custom font
	var custom_font = load("res://fonts/KiwiSoda.ttf")
	label_settings.font = custom_font
	
	# Create and set up the score label
	score_label = Label.new()
	score_label.text = "Hits: 0"
	score_label.label_settings = label_settings
	score_label.position = Vector2(18, 18)
	add_child(score_label)
	
	# Create and set up the timer label using the same settings
	timer_label = Label.new()
	timer_label.label_settings = label_settings  # Use the same label settings
	
	# Center the timer label at the top
	var viewport_size = get_viewport_rect().size
	timer_label.position = Vector2(viewport_size.x / 2 - 90, 18)
	add_child(timer_label)

func _process(delta: float) -> void:
	if game_active:
		# Update timer
		time_left -= delta
		timer_label.text = "Time: %d" % ceil(time_left)
		
		# Update score
		var misses = prevAttacks1 - Global.score
		prevAttacks1 = prevAttacks
		prevAttacks = Global.attacks
		score_label.text = "Hits: " + str(Global.score)
		
		# Check if time's up
		if time_left <= 0:
			game_active = false
			# Change to the end screen scene
			get_tree().change_scene_to_file("res://end_screen/end_scene.tscn")
