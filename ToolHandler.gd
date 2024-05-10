extends CanvasLayer

var game_size
var tools : Array
var yesNoWindow : Window

# Called when the node enters the scene tree for the first time.
func _ready():
	game_size = get_node("/root/Main").game_size
	tools = Array()
	self.get_viewport().set_embedding_subwindows(false)
	instantiate_buttons()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clamp_windows()
	unminimize_windows()
	pass

func _on_YesNoTool_pressed():
	if (yesNoWindow == null):
		yesNoWindow = instantiate_window()
		yesNoWindow.title = "Validation Tool"
		tools.append(yesNoWindow)
		return
	yesNoWindow.set_visible(not yesNoWindow.is_visible())

func _on_CloseWindow(window):
	window.hide()

func _on_QuitButton_pressed():
	get_tree().quit()

func instantiate_buttons():
	$YesNoTool.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$YesNoTool.position = Vector2(game_size[0] * 0.025, game_size[1] * 0.05)
	$Quit.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$Quit.position = Vector2(game_size[0] * 0.025, game_size[1] * 0.85)
	
func instantiate_window():
	var newWindow : Window = Window.new()
	self.add_child(newWindow)
	newWindow.always_on_top = true
	newWindow.transparent = true
	newWindow.transparent_bg = true
	newWindow.size = Vector2(game_size[0] * 0.25, game_size[1] * 0.3)
	newWindow.set_position(Vector2(game_size[0] * 0.5 - newWindow.size[0] * 0.5,
								   game_size[1] * 0.5 - newWindow.size[1] * 0.5))
	newWindow.unresizable = true
	newWindow.close_requested.connect(_on_CloseWindow.bind(newWindow))
	return newWindow

func clamp_windows():
	if (yesNoWindow != null):
		clamp_window(yesNoWindow)

func clamp_window(window):
	window.position.x = clamp(window.position.x, 0, game_size.x - window.size.x)
	window.position.y = clamp(window.position.y, 0, game_size.y - window.size.y)

func unminimize_windows():
	for window in tools:
		if (window.mode == Window.MODE_MINIMIZED):
			window.mode = Window.MODE_WINDOWED
