extends CanvasLayer

signal dialog_end

var halt_game
var game_size
var all_dialogs
var slow_time : bool
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	game_size = get_node("/root/Main").game_size
	all_dialogs = read_json_file("res://all_dialogs.json")
	print(all_dialogs[str(1)]["begin"][str(1)])
	initialize_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	halt_game = get_node("/root/Main").halt_game
	if (halt_game):
		return
	
	initialize_dialog()

func _on_dialog_begin(day, stage):
	var current_dialog = all_dialogs[str(day)][stage]
	var length = len(current_dialog)
	var min_time
	var max_time
	$Filter.visible = true
	$DialogBorder.visible = true
	$MouseCatcher.visible = true
	for i in range(1, length + 1):
		slow_time = false
		if (current_dialog[str(i)]["speaker"] == "CEO"):
			$DialogBorder.color = Color(1,1,1)
			$DialogBorder/DialogBg/Dialog.push_color(Color(1,1,1))
			min_time = 0.08
			max_time = 0.15
		elif (current_dialog[str(i)]["speaker"] == "hacker"):
			$DialogBorder.color = Color(1,0,0)
			$DialogBorder/DialogBg/Dialog.push_color(Color(1,0,0))
			min_time = 0.04
			max_time = 0.09
		var text = current_dialog[str(i)]["content"]
		var text_len = len(text)
		for j in range(text_len):
			await get_tree().create_timer(rng.randf_range(min_time, max_time)).timeout
			#get_node("SoundContainer/KeyPressSound" + str(rng.randi_range(1, 32))).play()
			$DialogBorder/DialogBg/Dialog.add_text(text[j])
		slow_time = true
		await $MouseCatcher.pressed
		$DialogBorder/DialogBg/Dialog.clear()
	$Filter.visible = false 
	$DialogBorder.visible = false
	$MouseCatcher.visible = false
	dialog_end.emit()

#func _input(event):
   ## Mouse in viewport coordinates.
	#if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
	#elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)

func initialize_dialog():
	$Filter.size = game_size
	$MouseCatcher.size = game_size
	
	$DialogBorder.size = Vector2(game_size[0] * 0.6, game_size[1] * 0.6)
	$DialogBorder.position = Vector2(game_size[0] * 0.5 - $DialogBorder.size[0] * 0.5,
									game_size[1] * 0.5 - $DialogBorder.size[1] * 0.5)
	
	$DialogBorder/DialogBg.size = $DialogBorder.size - Vector2(10, 10)
	$DialogBorder/DialogBg.position = Vector2(5, 5)
	
	$DialogBorder/DialogBg/Dialog.size = $DialogBorder/DialogBg.size - Vector2(50, 50)
	$DialogBorder/DialogBg/Dialog.position = Vector2(25, 25)
	
func read_json_file(file_path):
	var json = JSON.new()
	var file = FileAccess.open(file_path, FileAccess.READ)
	json.parse(file.get_as_text())
	file.close()
	return json.data
