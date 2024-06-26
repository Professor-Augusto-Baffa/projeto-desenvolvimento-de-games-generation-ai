extends CanvasLayer

var halt_game
var game_size
var tools : Array
var yesNoWindow : Window
var dialog : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	halt_game = get_node("/root/Main").halt_game
	game_size = get_node("/root/Main").game_size
	dialog = get_node("/root/Main").dialog
	tools = Array()
	self.get_viewport().set_embedding_subwindows(false)
	initialize_buttons()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (halt_game):
		return
	
	clamp_windows(tools)
	unminimize_windows(tools)

func _on_YesNoTool_pressed():
	if (yesNoWindow == null):
		yesNoWindow = initialize_window()
		yesNoWindow.title = "Validation Tool"
		tools.append(yesNoWindow)
		return
	yesNoWindow.set_visible(not yesNoWindow.is_visible())

func _on_CloseWindow(window):
	window.hide()

func _on_QuitButton_pressed():
	get_tree().quit()

func initialize_buttons():
	$YesNoTool.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$YesNoTool.position = Vector2(game_size[0] * 0.025, game_size[1] * 0.05)
	$Quit.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$Quit.position = Vector2(game_size[0] * 0.025, game_size[1] * 0.85)
	
func initialize_window():
	var newWindow : Window = Window.new()
	self.add_child(newWindow)
	newWindow.always_on_top = true
	newWindow.transparent = true
	newWindow.transparent_bg = true
	newWindow.size = Vector2(game_size[0] * 0.25, game_size[1] * 0.3)
	newWindow.position = Vector2(game_size[0] * 0.5 - newWindow.size[0] * 0.5,
								   game_size[1] * 0.5 - newWindow.size[1] * 0.5)
	newWindow.unresizable = true
	newWindow.close_requested.connect(_on_CloseWindow.bind(newWindow))
	return newWindow

func clamp_windows(windows):
	for window in windows:
		if (window != null):
			clamp_window(window)

func clamp_window(window):
	window.position.x = clamp(window.position.x, 0, game_size.x - window.size.x)
	window.position.y = clamp(window.position.y, 0, game_size.y - window.size.y)

func unminimize_windows(window_list):
	for window in window_list:
		if (window.mode == Window.MODE_MINIMIZED):
			window.mode = Window.MODE_WINDOWED
