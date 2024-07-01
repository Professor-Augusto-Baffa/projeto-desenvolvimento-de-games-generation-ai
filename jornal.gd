extends Control

var game_size = DisplayServer.screen_get_size()
# Called when the node enters the scene tree for the first time.
func _ready():
	$JornalMusic.play()
	$BgDesfoque.size = game_size
	$BgTransparente.size = game_size
	$ColorRect.size = Vector2(game_size.x/2, game_size.y * 0.9)
	$ColorRect.position = Vector2(game_size.x/2 - $ColorRect.size[0]/2, game_size.y/2 - $ColorRect.size[1]/2)
	$Border.size = Vector2(game_size.x/2 + 10, game_size.y * 0.9 + 10)
	$Border.position = Vector2(game_size.x/2 - $Border.size[0]/2, game_size.y/2 - $Border.size[1]/2)
	$ScrollContainer.size = Vector2(game_size.x/2.5, game_size.y * 0.8)
	$ScrollContainer.position = Vector2(game_size.x/2 - $ScrollContainer.size[0]/2, game_size.y/2 - $ScrollContainer.size[1]/2)
	#$ScrollContainer/VBoxContainer/Foto.size = Vector2(game_size.x/2.6, game_size.y * 0.7)
	$Button.size = Vector2(game_size.x * 0.1, game_size.y * 0.04)
	$Button.position = Vector2(game_size.x - game_size.x/4.5, game_size.y - game_size.y/6.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")
