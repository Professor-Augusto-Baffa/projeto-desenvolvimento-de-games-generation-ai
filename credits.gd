extends Node2D

var game_size = DisplayServer.screen_get_size()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.size = game_size
	$ColorRect.size = game_size
	$Vinheta.size = game_size
	
	$Logo.size = Vector2(game_size.x * 0.5, game_size.y * 0.1)
	$Logo.position = Vector2(game_size.x/2 - $Logo.size.x/2, game_size.y + $Logo.size.y)
	$CreditsText.position = Vector2(game_size.x/2 - $CreditsText.size.x/2, game_size.y + $CreditsText.size.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Logo.position.y -= 1
	$CreditsText.position.y -= 1
