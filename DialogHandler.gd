extends CanvasLayer

var game_size
# Called when the node enters the scene tree for the first time.
func _ready():
	game_size = get_node("/root/Main").game_size
	initialize_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	initialize_dialog()

func initialize_dialog():
	$DialogBg.size = Vector2(game_size[0] * 0.6, game_size[1] * 0.6)
	$DialogBg.set_position(Vector2(game_size[0] * 0.5 - $DialogBg.size[0] * 0.5,
								   game_size[1] * 0.5 - $DialogBg.size[1] * 0.5))
