extends Control

var game_size = DisplayServer.screen_get_size()
# Called when the node enters the scene tree for the first time.
func _ready():
	$BgDesfoque.size = game_size
	$ColorRect.size = Vector2(game_size[0]/2, game_size[1] * 0.9)
	$ColorRect.position = Vector2(game_size[0]/2 - $ColorRect.size[0]/2, game_size[1]/2 - $ColorRect.size[1]/2)
	$Border.size = Vector2(game_size[0]/2 + 10, game_size[1] * 0.9 + 10)
	$Border.position = Vector2(game_size[0]/2 - $Border.size[0]/2, game_size[1]/2 - $Border.size[1]/2)
	$ScrollContainer.size = Vector2(game_size[0]/2.5, game_size[1] * 0.8)
	$ScrollContainer.position = Vector2(game_size[0]/2 - $ScrollContainer.size[0]/2, game_size[1]/2 - $ScrollContainer.size[1]/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
