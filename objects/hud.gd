extends Control

var prevAttacks = 0
var prevAttacks1 = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var misses = prevAttacks1 - Global.score
	prevAttacks1 = prevAttacks
	prevAttacks = Global.attacks
	$Control/Score.text = "Hits: " + str(Global.score) + " Misses: " + str(misses)
