extends Node2D


# to exit the game throught a button
func _on_quit_pressed():
	get_tree().quit()

# to change scenes 
func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
