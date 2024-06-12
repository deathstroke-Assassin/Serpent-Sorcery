extends ParallaxBackground

var scrolling_speed = 100
# make the background move a little
func _process(delta):
	scroll_offset.x -= scrolling_speed * delta
	scroll_offset.y -= scrolling_speed * delta
	if Input.is_action_just_pressed("ui_menu"):
		get_tree().change_scene_to_file("res://main.tscn")
