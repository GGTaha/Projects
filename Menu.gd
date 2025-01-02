extends Control


signal start

func _ready():
	$VBoxContainer/Start.grab_focus()



func _on_Start_pressed():
	get_tree().change_scene("res://Game.tscn") 	
	emit_signal("start")


func _on_Quit_pressed():
	get_tree().quit()
