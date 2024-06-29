extends Node

signal dialog_begin(day, stage)

var halt_game : bool = false
var game_size = DisplayServer.screen_get_size()
var day : int = 0
var current_application : int
var points : int = 0
var time : Dictionary
var slow_time : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_viewport().set_embedding_subwindows(false)
	$Background.size = game_size
	$ToolBar.size = Vector2(game_size[0] * 0.15, game_size[1])
	initialize_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_application =  get_node("/root/Main/ApplicationHandler").current_application

func _pass_day():
	if (day != 0):
		dialog_begin.emit(day, "end")
		await $DialogHandler.dialog_end
	day += 1
	$dayLabel.text = "Day: " + str(day)
	time = {"hours": 3, "minutes": 0, "seconds": 0, "milisseconds": 0}
	slow_time = false
	dialog_begin.emit(day, "begin")

func _compute_points(variance):
	points += variance
	$pointLabel.text = "Points: " + str(points)

func initialize_labels():
	$dayLabel.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$dayLabel.position = Vector2(game_size[0] * 0.9, game_size[1] * 0.05)
	$dayLabel.show()
	$dayLabel.text = "Day: " + str(day)
	
	$pointLabel.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$pointLabel.position = Vector2(game_size[0] * 0.2, game_size[1] * 0.05)
	$pointLabel.show()
	$pointLabel.text = "Points: " + str(points)
