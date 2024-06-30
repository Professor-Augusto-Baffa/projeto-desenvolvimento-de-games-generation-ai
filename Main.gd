extends Node

signal dialog_begin(day, stage)

var halt_game : bool = false
var game_size = DisplayServer.screen_get_size()
var day : int = 0
var current_application : int
var points : int = 0
var time : Dictionary = {"hours": 3, "minutes": 0, "seconds": 0, "milisseconds": 0}
var slow_time : bool
var cumulative_slow_time : float
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_viewport().set_embedding_subwindows(false)
	rng.randomize()
	$Background.size = game_size
	$Circuitinho.size = Vector2(game_size[0] * 1.2, game_size[1] * 1.2)
	$ToolBar.size = Vector2(game_size[0] * 0.15, game_size[1])
	initialize_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_application =  get_node("/root/Main/ApplicationHandler").current_application
	slow_time = get_node("/root/Main/DialogHandler").slow_time
	
	process_time(delta)

func process_time(delta):
	if (slow_time):
		cumulative_slow_time += delta
		if (cumulative_slow_time >= 0.5):
			time["milisseconds"] += 1
			cumulative_slow_time -= 0.5
	else:
		delta *= 1000
		time["milisseconds"] += int(delta)
	if (time["milisseconds"] >= 1000):
		time["milisseconds"] -= 1000
		time["seconds"] += 1
	if (time["seconds"] >= 60):
		time["seconds"] -= 60
		time["minutes"] += 1
	if (time["minutes"] >= 60):
		time["minutes"] -= 60
		time["hours"] += 1
	$timeLabel.text = "%02d:%02d:%02d.%03d" % [time["hours"], time["minutes"], time["seconds"], time["milisseconds"]]

func _pass_day():
	if (day != 0):
		await get_tree().create_timer(1).timeout
		dialog_begin.emit(day, "end")
		await $DialogHandler.dialog_end
	day += 1
	$dayLabel.text = "Day: " + str(day)
	time = {"hours": 3, "minutes": rng.randi_range(0, 15), "seconds": rng.randi_range(0, 59), "milisseconds": 0}
	await get_tree().create_timer(1).timeout
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
	
	$timeLabel.size = Vector2(game_size[0] * 0.1, game_size[1] * 0.1)
	$timeLabel.position = Vector2(game_size[0] * 0.8, game_size[1] * 0.95)
	$timeLabel.show()
