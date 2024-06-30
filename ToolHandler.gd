extends CanvasLayer

var halt_game
var game_size
var tools : Array
var current_application
var yesNoWindow : Window
var was_visible : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	game_size = get_node("/root/Main").game_size
	tools = Array()
	was_visible = Array()
	self.get_viewport().set_embedding_subwindows(false)
	initialize_buttons()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	halt_game = get_node("/root/Main").halt_game
	if (halt_game):
		return
	
	current_application = get_node("/root/Main/ApplicationHandler").current_application
	if (current_application != null):
		verify_information()
	
	clamp_windows()
	unminimize_windows()

func _on_dialog_begin(_a,_b):
	if (was_visible.is_empty()):
		for tool in tools:
			if (tool.window.is_visible()):
				tool.window.visible = false
				was_visible.append(1)
			else:
				was_visible.append(0)

func _on_dialog_end(type):
	if (type == "interrupt"):
		for tool in tools:
			if (was_visible[0]):
				tool.window.visible = true
			was_visible.remove_at(0)

func _on_YesNoTool_pressed():
	if (yesNoWindow == null):
		yesNoWindow = initialize_window()
		yesNoWindow.title = "Verification Tool"
		var newTool = Tool.new(yesNoWindow)
		newTool.id = 1
		tools.append(newTool)
		return
	yesNoWindow.set_visible(not yesNoWindow.is_visible())

func _on_CloseWindow(window):
	window.hide()

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_app_processed(_a):
	for tool in tools:
		tool.reset_information()

func verify_information():
	var app_pos = current_application.window.position
	var app_size = current_application.window.size
	var t_pos
	var t_size
	for tool in tools:
		if (tool.window.is_visible()):
			t_pos = tool.window.position
			t_size = tool.window.size
			
			if (app_pos.x >= t_pos.x and app_pos.x <= t_pos.x + t_size.x and
			app_pos.x + app_size.x >= t_pos.x and app_pos.x + app_size.x <= t_pos.x + t_size.x and
			app_pos.y >= t_pos.y and app_pos.y <= t_pos.y + t_size.y and
			app_pos.y + app_size.y >= t_pos.y and app_pos.y + app_size.y <= t_pos.y + t_size.y):
				tool.update_information(current_application)
	
func initialize_window():
	var newWindow : Window = Window.new()
	self.add_child(newWindow)
	newWindow.always_on_top = true
	newWindow.transparent = true
	newWindow.transparent_bg = true
	newWindow.size = Vector2(game_size[0] * 0.3, game_size[1] * 0.35)
	newWindow.position = Vector2(game_size[0] * 0.5 - newWindow.size[0] * 0.5,
								   game_size[1] * 0.5 - newWindow.size[1] * 0.5)
	newWindow.unresizable = true
	newWindow.close_requested.connect(_on_CloseWindow.bind(newWindow))
	return newWindow

func clamp_windows():
	for tool in tools:
		if (tool.window != null):
			clamp_window(tool.window)

func clamp_window(window):
	window.position.x = clamp(window.position.x, 0, game_size.x - window.size.x)
	window.position.y = clamp(window.position.y, 0, game_size.y - window.size.y)

func unminimize_windows():
	for tool in tools:
		if (tool.window.mode == Window.MODE_MINIMIZED):
			tool.window.mode = Window.MODE_WINDOWED

func initialize_buttons():
	$YesNoTool.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$YesNoTool.position = Vector2(game_size[0] * 0.025, game_size[1] * 0.05)
	$Quit.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.17)
	$Quit.position = Vector2(game_size[0] * 0.025, game_size[1] * 0.8)
