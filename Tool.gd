class_name Tool extends Node

var window : Window
var id : int
var updated : bool = false

func _init(app):
	window = app
	var result = Label.new()
	result.add_theme_font_size_override("font_size", 30)
	window.add_child(result)

func update_information(application):
	if (not updated):
		var information
		var info_color
		updated = true
		match id:
			1:
				information = application.correctness
				if (information):
					info_color = Color(0, 1, 0)
					information = "Acceptable"
				else:
					info_color = Color(1, 0, 0)
					information = "Unacceptable"
			2:
				return
			_:
				return
		
		
		window.get_child(0).text = str(information)
		window.get_child(0).size = Vector2(40, 30)
		window.get_child(0).position = Vector2(window.size.x/2 - window.get_child(0).size.x/2,
												window.size.y/2 - window.get_child(0).size.y/2)
		window.get_child(0).add_theme_color_override("font_color", info_color)
		

func reset_information():
	window.get_child(0).text = ""
	updated = false
