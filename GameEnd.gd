extends CanvasLayer
signal back
signal newGame




func _on_BacktoGame_pressed():
	emit_signal("back")
	


func _on_NewGame_pressed():
	emit_signal("newGame")


func _on_MainMenu_pressed():
	get_tree().change_scene("res://Menu.tscn")
