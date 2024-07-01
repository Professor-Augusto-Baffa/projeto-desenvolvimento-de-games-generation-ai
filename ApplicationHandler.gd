extends CanvasLayer

signal next_day
signal app_processed(value)

var halt_game
var game_size
var applications : Array
var apps_per_day : int
var current_application : Application
var is_processing : bool
var processing_type : int
#var previous_what

# Called when the node enters the scene tree for the first time.
func _ready():
	game_size = get_node("/root/Main").game_size
	applications = Array()
	is_processing = false
	apps_per_day = 3
	initialize_processors()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	halt_game = get_node("/root/Main").halt_game
	if (halt_game):
		if (current_application.window.is_visible()):
			current_application.window.visible = false
		return
	
	if (applications.is_empty()):
		appendRandomApplications(apps_per_day)
		next_day.emit()
	
	if (current_application != null):
		if (is_processing and not current_application.window.is_visible()):
			current_application.window.visible = true
		
		unminimize_windows()
		clamp_windows()

func _on_dialog_begin(_a, type):
	if (current_application != null and current_application.window.is_visible()):
		current_application.window.visible = false
	if (type == "end"):
		is_processing = false

func _on_dialog_end(type):
	if (current_application != null and not current_application.window.is_visible()):
		current_application.window.visible = true
	if (type == "begin"):
		is_processing = true
		current_application = applications[0]

#func _notification(what):
	#if what == get_tree().NOTIFICATION_APPLICATION_FOCUS_IN:
		#print("a")
		#if (previous_what == get_tree().NOTIFICATION_APPLICATION_FOCUS_OUT):
			#print("c")
	#if what == get_tree().NOTIFICATION_APPLICATION_FOCUS_OUT:
		#print("b")
	#previous_what = what

#func _input(event):
	#print(event)
	#if event == get_tree().NOTIFICATION_APPLICATION_FOCUS_IN:
		#if (current_application != null and is_processing and not current_application.window.is_visible()):
			#current_application.window.visible = true
	#if event == get_tree().NOTIFICATION_APPLICATION_FOCUS_OUT:
		#if (current_application != null and is_processing and current_application.window.is_visible()):
			#current_application.window.visible = false

func appendRandomApplications(num):
	for i in range(num):
		var app = Application.new()
		app.window = initialize_window()
		app.window.title = str(i+1)
		app.correctness = true
		app.points = 1
		app.day_id = i + 1
		applications.append(app)

func initialize_window():
	var newWindow : Window = Window.new()
	newWindow.visible = false
	self.add_child(newWindow)
	newWindow.always_on_top = true
	newWindow.size = Vector2(game_size.x * 0.25, game_size.y * 0.3)
	newWindow.position = Vector2(game_size.x * 0.5 - newWindow.size[0] * 0.5,
								 game_size.y * 0.5 - newWindow.size[1] * 0.5)
	newWindow.unresizable = true
	return newWindow

func _entered(node):
	processing_type = node
	if (node == 1):
		$AcceptButton.size = Vector2(game_size.x * 0.1, game_size.y * 0.19)
		$AcceptButton.position = Vector2(game_size.x * 0.9 - $AcceptButton.size[0] * 0.5,
									   game_size.y * 0.365 - $AcceptButton.size[1] * 0.5)
	if (node == 2):
		$RejectButton.size = Vector2(game_size.x * 0.1, game_size.y * 0.19)
		$RejectButton.position = Vector2(game_size.x * 0.9 - $RejectButton.size[0] * 0.5,
										game_size.y * 0.565 - $RejectButton.size[1] * 0.5)

func _exited():
	processing_type = 0
	
	$AcceptButton.size = Vector2(game_size.x * 0.1, game_size.y * 0.12)
	$AcceptButton.position = Vector2(game_size.x * 0.9 - $AcceptButton.size[0] * 0.5,
									   game_size.y * 0.4 - $AcceptButton.size[1] * 0.5)
	
	$RejectButton.size = Vector2(game_size.x * 0.1, game_size.y * 0.12)
	$RejectButton.position = Vector2(game_size.x * 0.9 - $RejectButton.size[0] * 0.5,
									game_size.y * 0.6 - $RejectButton.size[1] * 0.5)

func initialize_processors():
	$AcceptButton.size = Vector2(game_size.x * 0.1, game_size.y * 0.12)
	$AcceptButton.position = Vector2(game_size.x * 0.9 - $AcceptButton.size[0] * 0.5,
									   game_size.y * 0.4 - $AcceptButton.size[1] * 0.5)
	
	$RejectButton.size = Vector2(game_size.x * 0.1, game_size.y * 0.12)
	$RejectButton.position = Vector2(game_size.x * 0.9 - $RejectButton.size[0] * 0.5,
									game_size.y * 0.6 - $RejectButton.size[1] * 0.5)


func clamp_windows():
	if (not applications.is_empty() and current_application != null):
		clamp_window(current_application.window)

func clamp_window(window):
	window.position.x = clamp(window.position.x, 0, game_size.x - window.size.x)
	window.position.y = clamp(window.position.y, 0, game_size.y - window.size.y)

func process_application():
	if (processing_type == 1):
		$AcceptedSound.play()
	elif (processing_type == 2):
		$RejectedSound.play()
	else:
		return
		
	var points
	if (processing_type != 0):
		match [processing_type, current_application.correctness]:
			[1,true]:
				points = current_application.points
			[1,false]:
				points = -current_application.points
			[2,true]:
				points = -current_application.points
			[2,false]:
				points = current_application.points
	current_application.window.visible = false
	current_application = null
	applications.remove_at(0)
	if (not applications.is_empty()):
		current_application = applications[0]
	app_processed.emit(points)

func unminimize_windows():
	if (not applications.is_empty() and current_application.window.mode == Window.MODE_MINIMIZED):
		current_application.window.mode = Window.MODE_WINDOWED
