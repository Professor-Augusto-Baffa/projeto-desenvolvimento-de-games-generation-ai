extends CanvasLayer

signal next_day
signal app_processed(value)

var halt_game
var game_size
var applications : Array
var apps_per_day : int
var is_processing_app : bool = false
var processing_type : int
var dialog : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	halt_game = get_node("/root/Main").halt_game
	game_size = get_node("/root/Main").game_size
	dialog = get_node("/root/Main").dialog
	applications = Array()
	apps_per_day = 3
	initialize_processors()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (halt_game):
		return
	
	if (applications.is_empty()):
		next_day.emit()
		appendRandomApplications(apps_per_day)
	
	if (not is_processing_app):
		summon_application()
	
	check_dialog()
	
	unminimize_windows()
	clamp_windows()

func check_dialog():
	if (dialog && applications[0].window.is_visible()):
		applications[0].window.visible = false
	elif (not dialog):
		applications[0].window.visible = true

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_position = get_viewport().get_mouse_position()
		print(mouse_position)

func appendRandomApplications(num):
	for i in range(num):
		var app = Application.new()
		app.window = initialize_window()
		app.window.title = str(i+1)
		app.correctness = true
		app.points = 1
		applications.append(app)

func initialize_window():
	var newWindow : Window = Window.new()
	newWindow.hide()
	self.add_child(newWindow)
	newWindow.always_on_top = true
	newWindow.size = Vector2(game_size[0] * 0.25, game_size[1] * 0.3)
	newWindow.position = Vector2(game_size[0] * 0.5 - newWindow.size[0] * 0.5,
								 game_size[1] * 0.5 - newWindow.size[1] * 0.5)
	newWindow.unresizable = true
	return newWindow

func _entered(node):
	processing_type = node
	print(processing_type)

func _exited():
	processing_type = 0
	print(processing_type)

func initialize_processors():
	$Accept.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$Accept.position = Vector2(game_size[0] * 0.9 - $Accept.size[0] * 0.5,
								 game_size[1] * 0.4 - $Accept.size[1] * 0.5)
	
	$Reject.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$Reject.position = Vector2(game_size[0] * 0.9 - $Reject.size[0] * 0.5,
								 game_size[1] * 0.6 - $Reject.size[1] * 0.5)
								
	$AcceptButton.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$AcceptButton.position = Vector2(game_size[0] * 0.9 - $AcceptButton.size[0] * 0.5,
									   game_size[1] * 0.4 - $AcceptButton.size[1] * 0.5)
	
	$RejectButton.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$RejectButton.position = Vector2(game_size[0] * 0.9 - $RejectButton.size[0] * 0.5,
									game_size[1] * 0.6 - $RejectButton.size[1] * 0.5)

func summon_application():
	applications[0].window.show()
	is_processing_app = true
	
func clamp_windows():
	if (applications[0] != null):
		clamp_window(applications[0].window)

func clamp_window(window):
	window.position.x = clamp(window.position.x, 0, game_size.x - window.size.x)
	window.position.y = clamp(window.position.y, 0, game_size.y - window.size.y)

func process_application():
	var points
	if (processing_type != 0):
		match [processing_type, applications[0].correctness]:
			[1,true]:
				points = applications[0].points
			[1,false]:
				points = -applications[0].points
			[2,true]:
				points = -applications[0].points
			[2,false]:
				points = applications[0].points
	
	applications[0].window.hide()
	applications.remove_at(0)
	app_processed.emit(points)
	is_processing_app = false

func unminimize_windows():
	if (applications[0].window.mode == Window.MODE_MINIMIZED):
		applications[0].window.mode = Window.MODE_WINDOWED
