extends Control

var game_size = DisplayServer.screen_get_size()

# Called when the node enters the scene tree for the first time.
func _ready():
	$CreditsMusic.play()
	
	$Background.size = game_size
	$ColorRect.size = game_size
	$Vinheta.size = game_size
	$Transition/Black.size = game_size
	
	$Logo.size = Vector2(game_size.x * 0.5, game_size.y * 0.1)
	$Logo.position = Vector2(game_size.x/2 - $Logo.size.x/2, game_size.y + $Logo.size.y)
	$CreditsText.size.x = game_size.x/2
	$CreditsText.position = Vector2(game_size.x/2 - $CreditsText.size.x/2, game_size.y + ($Logo.size.y * 2))
	$Transition.play("fade_in_credits")
	await get_tree().create_timer(3.5).timeout
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Logo.position.y -= 2
	$CreditsText.position.y -= 2
	
func _on_timer_timeout():
	get_tree().change_scene_to_file("res://main_menu.tscn")
