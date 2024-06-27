extends CanvasLayer

var halt_game
var game_size
var dialog
# Called when the node enters the scene tree for the first time.
func _ready():
	halt_game = get_node("/root/Main").halt_game
	game_size = get_node("/root/Main").game_size
	dialog = get_node("/root/Main").dialog
	initialize_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (halt_game || not dialog):
		return
	
	initialize_dialog()

func initialize_dialog():
	$DialogBorder.size = Vector2(game_size[0] * 0.6, game_size[1] * 0.6)
	$DialogBorder.position = Vector2(game_size[0] * 0.5 - $DialogBorder.size[0] * 0.5,
									game_size[1] * 0.5 - $DialogBorder.size[1] * 0.5)
	
	$DialogBorder/DialogBg.size = $DialogBorder.size - Vector2(10, 10)
	$DialogBorder/DialogBg.position = Vector2(5, 5)
	
	$DialogBorder/DialogBg/Dialog.size = $DialogBorder/DialogBg.size
	$DialogBorder/DialogBg/Dialog.position = $DialogBorder/DialogBg.position
	
	$DialogBorder/DialogBg/Dialog.push_color(Color(1,0,0))
	$DialogBorder/DialogBg/Dialog.add_text("some white text\n")
	$DialogBorder/DialogBg/Dialog.add_text("some white text\n")
	$DialogBorder/DialogBg/Dialog.pop()
	$DialogBorder/DialogBg/Dialog.add_text("some white text\n")
