extends Node

signal dialog_begin(day, stage)

var halt_game : bool = false
var game_size = DisplayServer.screen_get_size()
var day : int = 0
var current_application
var points : int = 0
var time
var slow_time : bool
var cumulative_slow_time : float
var interrupting : bool = false
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.

func _ready():
	self.get_viewport().set_embedding_subwindows(false)
	rng.randomize()
	$AmbientMusic.play()
	$Background.size = game_size
	$Transition/Black.size = game_size
	$Circuitinho.size = Vector2(game_size.x * 1.2, game_size.y * 1.2)
	$Circuitinho.position = Vector2(game_size.x/2 - $Circuitinho.size[0]/2, game_size.y/2 - $Circuitinho.size[1]/2)
	$ToolBar.size = Vector2(game_size.x * 0.15, game_size.y)
	$DialogHandler/MouseCatcher.visible = true
	initialize_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_application = get_node("/root/Main/ApplicationHandler").current_application
	slow_time = get_node("/root/Main/DialogHandler").slow_time
	process_time(delta)
	
	if (current_application != null and not interrupting):
		interrupt_dialog(current_application.day_id)

func process_time(delta):
	if (time != null):
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
		$DialogHandler/MouseCatcher.visible = true
		await get_tree().create_timer(1).timeout
		$DialogHandler/MouseCatcher.visible = false
		
		dialog_begin.emit(day, "end")
		
		await $DialogHandler.dialog_end
		
		$DialogHandler/MouseCatcher.visible = true
		$Transition.play("fade_out_main")
		$OffSound.play()
		await get_tree().create_timer(4).timeout
		if (day == 2):
			get_tree().change_scene_to_file("res://credits.tscn")
			return
	
	$Transition/Black/dayLabel.text = "Day: " + str(day)
	$Transition/Black/dayLabel.visible = true
	await get_tree().create_timer(2).timeout
	day += 1
	$Transition/Black/dayLabel.text = "Day: " + str(day)
	get_node("/root/Main/DialogHandler/SoundContainer/KeyPressSound" + str(rng.randi_range(1, 32))).play()
	await get_tree().create_timer(2).timeout
	$Transition/Black/pointLabel.visible = true
	get_node("/root/Main/DialogHandler/SoundContainer/KeyPressSound" + str(rng.randi_range(1, 32))).play()
	await get_tree().create_timer(3).timeout
	$Transition/Black/dayLabel.visible = false
	$Transition/Black/pointLabel.visible = false
	
	time = {"hours": 3, "minutes": rng.randi_range(0, 14), "seconds": rng.randi_range(0, 59), "milisseconds": rng.randi_range(0, 999)}
	
	
	$Transition.play("fade_in_main")
	$OnSound.play()
	await get_tree().create_timer(4).timeout
	$DialogHandler/MouseCatcher.visible = false
	
	dialog_begin.emit(day, "begin")

func _compute_points(variance):
	points += variance
	$Transition/Black/pointLabel.text = "Points: " + str(points)

func _on_dialog_end(type):
	if ("interrupt" in type):
		interrupting = false

func interrupt_dialog(id):
	if (day == 2 and id == 2):
		interrupting = true
		await get_tree().create_timer(1).timeout
		dialog_begin.emit(day, "interrupt1")

func initialize_labels():
	$Transition/Black/dayLabel.size = Vector2(game_size.x * 0.1, game_size.y * 0.1)
	$Transition/Black/dayLabel.position = Vector2(game_size.x/2 - $Transition/Black/dayLabel.size.x/2, game_size.y/3 - $Transition/Black/dayLabel.size.y/2)
	
	$Transition/Black/pointLabel.size = Vector2(game_size.x * 0.1, game_size.y * 0.1)
	$Transition/Black/pointLabel.position = Vector2(game_size.x/2 - $Transition/Black/pointLabel.size.x/2, game_size.y/1.5 - $Transition/Black/pointLabel.size.y/2)
	
	$timeLabel.size = Vector2(game_size.x * 0.1, game_size.y * 0.1)
	$timeLabel.position = Vector2(game_size.x * 0.8, game_size.y * 0.9)
	$timeLabel.show()
