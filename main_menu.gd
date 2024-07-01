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
	$Transition.play("fade_out")
	$MenuMusic.stop()
	get_tree().change_scene_to_file("res://jornal.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func initialize_buttons():
	$Background.size = game_size
	$ColorRect.size = game_size
	$TextureRect.size = game_size
	
	$Logo.size = Vector2(game_size.x * 0.5, game_size.y * 0.1)
	$Logo.position = Vector2(game_size.x/1.95 - $Logo.size[0]/2,
								game_size.y/5.4 - $Logo.size[1]/2)
	
	$Subtitle.size = Vector2(game_size.x * 0.32, game_size.y * 0.07)
	$Subtitle.position = Vector2(game_size.x/1.88 - $Logo.size[0]/2,
								game_size.y/2.85 - $Subtitle.size[1]/2)
								
	$NewGame.size = Vector2(game_size.x * 0.2, game_size.y * 0.1)
	$NewGame.position = Vector2(game_size.x/2 - $NewGame.size[0]/2,
								game_size.y/2 - $NewGame.size[1]/2)
	
	$Quit.size = Vector2(game_size.x * 0.2, game_size.y * 0.1)
	$Quit.position = Vector2(game_size.x/2 - $Quit.size[0]/2,
							game_size.y * 0.9 - $Quit.size[1]/2)
