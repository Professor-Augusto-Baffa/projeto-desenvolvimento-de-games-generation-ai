extends Control

var game_size = DisplayServer.screen_get_size()
# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuMusic.play()
	initialize_buttons()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_NewGame_pressed():
	$MenuMusic.stop()
	get_tree().change_scene_to_file("res://Main.tscn")

func initialize_buttons():
	$Background.size = Vector2(game_size[0], game_size[1])
	$ColorRect.size = Vector2(game_size[0], game_size[1])
	$NewGame.size = Vector2(game_size[0] * 0.2, game_size[1] * 0.1)
	$NewGame.position = Vector2(game_size[0]/2 - $NewGame.size[0]/2,
								game_size[1]/2 - $NewGame.size[1]/2)
	
	$Quit.size = Vector2(game_size[0] * 0.2, game_size[1] * 0.1)
	$Quit.position = Vector2(game_size[0]/2 - $Quit.size[0]/2,
							game_size[1] * 0.9 - $Quit.size[1]/2)
