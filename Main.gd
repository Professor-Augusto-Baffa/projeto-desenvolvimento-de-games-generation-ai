extends Node

var halt_game : bool = true
var game_size = DisplayServer.screen_get_size()
var dialog : bool = false
var current_dialog : Dictionary
var day : int = 0
var points : int = 0
var time : Dictionary
var slow_time : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_viewport().set_embedding_subwindows(false)
	$Background.size = game_size
	$ToolBar.size = Vector2(game_size[0] * 0.15, game_size[1])
	initialize_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _input(event):
   ## Mouse in viewport coordinates.
	#if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
	#elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
#
   ## Print the size of the viewport.
	#print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)

func begin_day_dialog():
	match day:
		1:
			#current_dialog = 
			pass
		2:
			pass
		3:
			pass
		_:
			pass

func end_day_dialog():
	match day:
		1:
			pass
		2:
			pass
		3:
			pass
		_:
			pass

func new_game():
	pass

func _pass_day():
	end_day_dialog()
	day += 1
	$dayLabel.text = "Day: " + str(day)
	begin_day_dialog()

func _compute_points(variance):
	points += variance
	$pointLabel.text = "Points: " + str(points)

func initialize_labels():
	$dayLabel.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$dayLabel.position = Vector2(game_size[0] * 0.9, game_size[1] * 0.05)
	$dayLabel.show()
	$dayLabel.text = "Day: " + str(day)
	
	$pointLabel.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$pointLabel.position = Vector2(game_size[0] * 0.2, game_size[1] * 0.05)
	$pointLabel.show()
	$pointLabel.text = "Points: " + str(points)
